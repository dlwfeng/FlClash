import 'dart:convert';
import 'dart:io';

import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/remote/desktop.dart';
import 'package:fl_clash/state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';

class _Core extends Mock implements CoreController {}

void main() {
  late ProviderContainer container;
  late DesktopRemoteControl remote;
  late HttpClient http;
  late _Core core;

  setUp(() async {
    await AppLocalizations.load(const Locale('en'));
    core = _Core();
    container = ProviderContainer(
      overrides: [
        ...buildConfigOverrides(
          const Config(
            themeProps: defaultThemeProps,
            patchClashConfig: PatchClashConfig(secret: 'test-secret'),
          ),
        ),
        profilesProvider.overrideWithBuild((_, _) => []),
        initProvider.overrideWithBuild((_, _) => true),
        coreHandlerProvider.overrideWithValue(core),
      ],
    );
    container.listen(configProvider, (_, _) {});
    container.listen(initProvider, (_, _) {});
    globalState.packageInfo = PackageInfo(
      appName: 'FlClash',
      packageName: 'test',
      version: '1.0',
      buildNumber: '1',
    );
    remote = DesktopRemoteControl(container);
    await remote.server.start(port: 0);
    http = HttpClient();
  });

  tearDown(() async {
    http.close(force: true);
    await remote.close();
    container.dispose();
  });

  Future<(int, Map<String, dynamic>)> send(
    String method,
    String path, [
    Object? body,
  ]) async {
    final request = await http.openUrl(
      method,
      Uri.parse('http://127.0.0.1:${remote.server.boundPort}$path'),
    );
    request.headers.set('Authorization', 'Bearer test-secret');
    if (body != null) request.write(jsonEncode(body));
    final response = await request.close();
    return (
      response.statusCode,
      jsonDecode(await response.transform(utf8.decoder).join())
          as Map<String, dynamic>,
    );
  }

  test('state works without the optional 9090 controller', () async {
    final response = await send('GET', '/api/state');
    expect(response.$1, 200);
    final config = response.$2['data']['config'] as Map;
    expect(
      config['patchClashConfig']['external-controller'],
      isNot('127.0.0.1:9090'),
    );
    expect(response.$2['data']['ready'], true);
    verifyZeroInteractions(core);
  });

  test(
    'settings updates reach desktop providers and reject stale edits',
    () async {
      final state = (await send('GET', '/api/state')).$2['data'] as Map;
      final previous = state['config']['networkProps'] as Map;
      final next = {
        ...previous,
        'systemProxy': !(previous['systemProxy'] as bool),
      };
      final payload = {
        'section': 'networkProps',
        'expected': previous,
        'value': next,
      };
      expect((await send('PATCH', '/api/settings', payload)).$1, 200);
      expect(
        container.read(networkSettingProvider).systemProxy,
        next['systemProxy'],
      );
      expect((await send('PATCH', '/api/settings', payload)).$1, 409);
      expect(
        container.read(networkSettingProvider).systemProxy,
        next['systemProxy'],
      );
      verifyZeroInteractions(core);
    },
  );

  test('connection control calls the existing Core facade', () async {
    when(() => core.closeConnection('connection-id')).thenAnswer((_) async {});
    final response = await send('POST', '/api/command', {
      'command': 'closeConnection',
      'id': 'connection-id',
    });
    expect(response.$1, 200);
    verify(() => core.closeConnection('connection-id')).called(1);
  });

  test('uninitialized application rejects mutations', () async {
    container.read(initProvider.notifier).value = false;
    expect(
      (await send('POST', '/api/command', {'command': 'restart'})).$1,
      503,
    );
    expect(
      (await send('PATCH', '/api/settings', {
        'section': 'networkProps',
        'expected': {},
        'value': {},
      })).$1,
      503,
    );
    verifyZeroInteractions(core);
  });

  test('unknown IDs cannot become filesystem paths', () async {
    final response = await send('POST', '/api/command', {
      'command': 'readProfile',
      'id': '../shared_preferences',
    });
    expect(response.$1, 404);
    verifyZeroInteractions(core);
  });
  test(
    'WebDAV passwords cross the API as secrets and persist in native format',
    () async {
      container.read(davSettingProvider.notifier).value = const DAVProps(
        uri: 'https://example.com/dav',
        user: 'user',
        password: 'old secret',
      );
      final config =
          (await send('GET', '/api/state')).$2['data']['config'] as Map;
      final previous = config['davProps'] as Map;
      expect(previous['password'], 'old secret');
      expect(
        (await send('PATCH', '/api/settings', {
          'section': 'davProps',
          'expected': previous,
          'value': {...previous, 'password': 'new secret'},
        })).$1,
        200,
      );
      expect(container.read(davSettingProvider)?.password, 'new secret');
      final next =
          (await send('GET', '/api/state')).$2['data']['config'] as Map;
      final network = next['networkProps'] as Map;
      expect(
        (await send('PATCH', '/api/settings', {
          'section': 'networkProps',
          'expected': network,
          'value': {...network, 'systemProxy': false},
        })).$1,
        200,
      );
      expect(container.read(davSettingProvider)?.password, 'new secret');
    },
  );
}
