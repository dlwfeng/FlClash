import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui' show Brightness;

import 'package:collection/collection.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/database/database.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import 'server.dart';

class DesktopRemoteControl {
  DesktopRemoteControl(this.container) {
    server = RemoteControlServer(
      secret: () => container.read(patchClashConfigProvider).secret,
      handleApi: _handle,
      readAsset: _readAsset,
      allowedHosts: {
        ...RemoteControlServer.defaultHosts,
        ...?Platform.environment['FLCLASH_WEB_HOSTS']
            ?.split(',')
            .map((host) => host.trim().toLowerCase())
            .where((host) => host.isNotEmpty),
      },
      allowedOrigins: {
        ...?Platform.environment['FLCLASH_WEB_ORIGINS']
            ?.split(',')
            .map((origin) => origin.trim())
            .where((origin) => origin.isNotEmpty),
      },
      onError: (error, stack) {
        commonPrint.log(
          'Remote control: ${compactError(error)}',
          logLevel: LogLevel.warning,
        );
      },
    );
  }

  final ProviderContainer container;
  late final RemoteControlServer server;
  CoreController get _core => container.read(coreHandlerProvider);

  Future<void> start() => server.start();

  Future<void> close() => server.close();

  Uri get uri => Uri(
    scheme: 'http',
    host: '127.0.0.1',
    port: RemoteControlServer.port,
    fragment: Uri(
      queryParameters: {
        'secret': container.read(patchClashConfigProvider).secret,
      },
    ).query,
  );

  Future<List<int>?> _readAsset(String path) async {
    final executable = p.dirname(Platform.resolvedExecutable);
    final roots = [
      if (Platform.environment['FLCLASH_WEB_ROOT'] case final String root) root,
      p.join(executable, 'remote-web'),
      if (Platform.isMacOS)
        p.normalize(p.join(executable, '..', 'Resources', 'remote-web')),
      p.join(Directory.current.path, 'build', 'remote-web'),
    ];
    for (final root in roots) {
      final file = File(p.join(root, path));
      if (!await file.exists()) continue;
      final resolvedRoot = await Directory(root).resolveSymbolicLinks();
      final resolvedFile = await file.resolveSymbolicLinks();
      if (p.isWithin(resolvedRoot, resolvedFile)) return file.readAsBytes();
    }
    return null;
  }

  Future<Object?> _handle(String method, String path, Object? body) async {
    if (method == 'GET') {
      return switch (path) {
        '/api/state' => _state(),
        '/api/connections' => await _core.getConnections(),
        '/api/logs' => container.read(logsProvider).list,
        '/api/requests' => container.read(requestsProvider).list,
        '/api/dns' => container.read(dnsQueriesProvider).list,
        '/api/resources' => await _resources(),
        _ => throw const RemoteApiException(404, 'Unknown endpoint'),
      };
    }
    final args = body is Map ? Map<String, Object?>.from(body) : null;
    if (args == null) {
      throw const RemoteApiException(400, 'Expected a JSON object');
    }
    if (!container.read(initProvider)) {
      throw const RemoteApiException(
        503,
        'Desktop application is initializing',
      );
    }
    if (method == 'PATCH' && path == '/api/settings') {
      return _patchSettings(args);
    }
    if (method != 'POST' || path != '/api/command') {
      throw const RemoteApiException(404, 'Unknown endpoint');
    }
    try {
      return await _command(args);
    } on AgeSecretKeyRequiredException {
      throw RemoteApiException(
        422,
        currentAppLocalizations.ageSecretKeyRequiredTip,
      );
    } on MessageException catch (error) {
      throw RemoteApiException(422, error.message);
    }
  }

  Map<String, Object?> _state() {
    final profile = container.read(currentProfileProvider);
    return {
      'protocol': 1,
      'version': globalState.packageInfo.version,
      'platform': Platform.operatingSystem,
      'themeSeeds': {
        for (final brightness in Brightness.values)
          brightness.name: container
              .read(dynamicColorProvider)
              .seedOf(brightness)
              .toARGB32(),
      },
      'ready': container.read(initProvider),
      'safeMode': safeModeBuild,
      'coreStatus': container.read(coreStatusProvider).name,
      'running': container.read(isStartProvider),
      'config': _configJson(container.read(configProvider)),
      'profiles': container.read(profilesProvider),
      'groups': container.read(groupsProvider),
      'selectedMap': profile?.selectedMap ?? const {},
      'delays': container.read(delayDataSourceProvider),
      'traffic': container.read(trafficsProvider).list.lastOrNull,
      'totalTraffic': container.read(totalTrafficProvider),
    };
  }

  static Map<String, Object?> _configJson(Config config) {
    return {
      ...config.toJson(),
      if (config.davProps case final dav?)
        'davProps': {...dav.toJson(), 'password': dav.password},
    };
  }

  Future<Map<String, Object?>> _resources() async {
    final (scripts, providers, icons, proxies, rules) = await (
      database.scriptsDao.query().get(),
      database.clashProvidersDao.query().get(),
      database.iconSetsDao.query().get(),
      database.customProxiesDao.query().get(),
      database.rulesDao.queryGlobalRules().get(),
    ).wait;
    return {
      'scripts': scripts,
      'providers': providers,
      'iconSets': icons,
      'proxies': proxies,
      'rules': rules,
      'externalProviders':
          container.read(coreStatusProvider) == CoreStatus.connected
          ? await _core.getExternalProviders()
          : const [],
    };
  }

  Future<Object?> _command(Map<String, Object?> args) async {
    switch (args['command']) {
      case 'running':
        return container
            .read(setupActionProvider.notifier)
            .setRunning(_boolean(args, 'value'), initialize: true);
      case 'restart':
        return container.read(coreActionProvider.notifier).restartCore();
      case 'apply':
        return container
            .read(setupActionProvider.notifier)
            .applyProfile(force: true);
      case 'selectProxy':
        await container
            .read(proxiesActionProvider.notifier)
            .changeProxy(
              groupName: _string(args, 'group'),
              proxyName: _string(args, 'proxy'),
            );
        return null;
      case 'delay':
        final delay = await _core.getDelay(
          _string(args, 'url'),
          _string(args, 'proxy'),
          const Duration(milliseconds: defaultDelayTestTimeout),
        );
        if (delay != null) {
          container.read(proxiesActionProvider.notifier).setDelay(delay);
        }
        return delay;
      case 'closeConnection':
        await _core.closeConnection(_string(args, 'id'));
        return null;
      case 'closeConnections':
        await _core.closeConnections();
        return null;
      case 'clearDnsCache':
        return _core.clearDnsCache();
      case 'selectProfile':
        final profile = _profile(args);
        container.read(currentProfileIdProvider.notifier).value = profile.id;
        return container
            .read(setupActionProvider.notifier)
            .applyProfile(force: true);
      case 'updateProfile':
        await container
            .read(profilesActionProvider.notifier)
            .updateProfile(_profile(args));
        return null;
      case 'deleteProfile':
        await container
            .read(profilesActionProvider.notifier)
            .deleteProfile(_profile(args).id);
        return null;
      case 'updateProfiles':
        await container.read(profilesActionProvider.notifier).updateProfiles();
        return null;
      case 'addProfile':
        await _addProfile(args);
        return null;
      case 'readProfile':
        final profile = _profile(args);
        if (profile.type == ProfileType.custom) {
          return container
              .read(setupActionProvider.notifier)
              .getProfileWithId(profile.id);
        }
        return File(
          await appPath.getProfilePath('${profile.id}'),
        ).readAsString();
      case 'saveProfile':
        final profile = _profile(args);
        final content = _string(args, 'content');
        final action = container.read(profilesActionProvider.notifier);
        if (profile.type == ProfileType.custom) {
          final parsed = await action.readCustomImport(
            profile.id,
            utf8.encode(content),
          );
          await action.importCustomProfile(profile.id, parsed);
        } else {
          final error = await _core.validateConfigWithData(
            utf8.encode(content),
          );
          if (error.isNotEmpty) throw RemoteApiException(422, error);
          await File(
            await appPath.getProfilePath('${profile.id}'),
          ).safeWriteAsString(content);
          action.touchProfile(profile.id);
        }
        if (container.read(currentProfileIdProvider) == profile.id) {
          await container
              .read(setupActionProvider.notifier)
              .applyProfile(force: true);
        }
        return null;
      case 'updateResources':
        final failures = await container
            .read(resourcesActionProvider.notifier)
            .updateAll();
        return [
          for (final failure in failures)
            {'label': failure.label, 'message': failure.message},
        ];
      case 'updateProvider':
        return _core.updateExternalProvider(
          providerName: _string(args, 'name'),
        );
      case 'gc':
        await container.read(coreActionProvider.notifier).requestGc();
        return null;
      default:
        throw const RemoteApiException(400, 'Unknown command');
    }
  }

  Future<void> _addProfile(Map<String, Object?> args) async {
    final action = container.read(profilesActionProvider.notifier);
    final url = args['url'];
    if (url is String && url.isNotEmpty) {
      final updated = await action.profileFromLink(
        url,
        label: _string(args, 'label'),
        ageSecretKey: args['ageSecretKey'] as String? ?? '',
        promptForSecret: false,
      );
      action.putProfile(updated);
      return;
    }
    final data = args['data'];
    final bytes = data is String
        ? base64Decode(data)
        : utf8.encode(_string(args, 'content'));
    final profile = Profile.normal(
      label: _string(args, 'label'),
    ).copyWith(ageSecretKey: args['ageSecretKey'] as String? ?? '');
    final file = File(await appPath.getProfilePath('${profile.id}'));
    await file.safeWriteAsBytes(bytes);
    try {
      final error = await _core.validateProfile(
        file.path,
        profile.ageSecretKey,
      );
      if (error.isNotEmpty) throw RemoteApiException(422, error);
    } catch (_) {
      await file.safeDelete();
      rethrow;
    }
    action.putProfile(profile);
  }

  Future<Object?> _patchSettings(Map<String, Object?> args) async {
    final section = _string(args, 'section');
    final previous = container.read(configProvider);
    final config = await Isolate.run(() => _parseSettings(previous, args));
    if (!identical(container.read(configProvider), previous)) {
      throw const RemoteApiException(
        409,
        'Settings changed on the desktop; reload before saving',
      );
    }
    switch (section) {
      case 'appSettingProps':
        container.read(appSettingProvider.notifier).value =
            config.appSettingProps;
      case 'networkProps':
        container.read(networkSettingProvider.notifier).value =
            config.networkProps;
      case 'themeProps':
        container.read(themeSettingProvider.notifier).value = config.themeProps;
      case 'patchClashConfig':
        if (config.patchClashConfig.secret.trim().isEmpty) {
          throw const RemoteApiException(
            400,
            'The controller secret must not be empty',
          );
        }
        container.read(patchClashConfigProvider.notifier).value = config
            .patchClashConfig
            .ensureControllerSecret();
      case 'proxiesStyleProps':
        container.read(proxiesStyleSettingProvider.notifier).value =
            config.proxiesStyleProps;
      case 'davProps':
        container.read(davSettingProvider.notifier).value = config.davProps;
      default:
        throw const RemoteApiException(400, 'Settings section is unavailable');
    }
    return null;
  }

  static Config _parseSettings(Config previous, Map<String, Object?> args) {
    final section = _string(args, 'section');
    final value = args['value'];
    final current = jsonDecode(jsonEncode(_configJson(previous))) as Map;
    if (!current.containsKey(section) || value is! Map) {
      throw const RemoteApiException(400, 'Unknown settings section');
    }
    if (!const DeepCollectionEquality().equals(
      current[section],
      args['expected'],
    )) {
      throw const RemoteApiException(
        409,
        'Settings changed on the desktop; reload before saving',
      );
    }
    final Config config;
    try {
      final input = {...current.cast<String, Object?>(), section: value};
      final dav = previous.davProps;
      if (section == 'davProps') {
        final fields = Map<String, Object?>.from(value);
        input['davProps'] = DAVProps(
          uri: _string(fields, 'uri'),
          user: _string(fields, 'user'),
          password: _string(fields, 'password'),
          fileName: fields['fileName'] as String? ?? defaultDavFileName,
        ).toJson();
      } else if (dav != null) {
        input['davProps'] = dav.toJson();
      }
      config = Config.strictFromJson(input);
    } catch (_) {
      throw const RemoteApiException(400, 'Invalid settings');
    }
    return config;
  }

  Profile _profile(Map<String, Object?> args) {
    final id = args['id'];
    final profile = container
        .read(profilesProvider)
        .firstWhereOrNull((profile) => '${profile.id}' == '$id');
    if (profile == null) {
      throw const RemoteApiException(404, 'Profile not found');
    }
    return profile;
  }

  static String _string(Map<String, Object?> args, String key) {
    final value = args[key];
    if (value is! String) throw RemoteApiException(400, 'Expected $key');
    return value;
  }

  static bool _boolean(Map<String, Object?> args, String key) {
    final value = args[key];
    if (value is! bool) throw RemoteApiException(400, 'Expected $key');
    return value;
  }
}

DesktopRemoteControl? desktopRemoteControl;
