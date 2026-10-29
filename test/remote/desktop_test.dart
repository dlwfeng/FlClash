import 'package:fl_clash/providers/ip_quality.dart';
import 'package:fl_clash/providers/probe_activity.dart';
import 'package:fl_clash/remote/dashboard_watch.dart';
import 'package:fl_clash/common/service_probe.dart';
import 'package:fl_clash/providers/outbound_ip.dart';
import 'package:fl_clash/providers/service_status.dart';
import 'package:fl_clash/providers/routed_probe.dart';
import 'dart:convert';
import 'dart:io';

import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/enum/enum.dart';
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

class _Outbound extends OutboundIpProbe {
  static final watched = <String>{};
  @override
  void watch(String target) => watched.add(target);
  @override
  void unwatch(String target) => watched.remove(target);
  static int refreshes = 0;
  @override
  RoutedProbeState<String, IpInfo> build() => const RoutedProbeState({
    '': ProbeEntry(
      phase: ProbePhase.fresh,
      value: IpInfo(ip: '192.0.2.5', countryCode: 'US'),
    ),
  });
  @override
  void refresh(Iterable<String> targets) {
    refreshes++;
  }
}

class _Services extends ServiceStatus {
  static final watched = <ServiceTarget>{};
  @override
  void watch(ServiceTarget target) => watched.add(target);
  @override
  void unwatch(ServiceTarget target) => watched.remove(target);
  static int refreshes = 0;
  @override
  RoutedProbeState<ServiceTarget, ServiceCheck> build() =>
      const RoutedProbeState({
        ServiceTarget.google: ProbeEntry(
          phase: ProbePhase.fresh,
          value: ServiceCheck(ServiceProbeStatus.available, delay: 42),
        ),
      });
  @override
  void refresh(Iterable<ServiceTarget> targets) {
    refreshes++;
  }
}

class _Core extends Mock implements CoreController {}

void main() {
  late ProviderContainer container;
  late DesktopRemoteControl remote;
  late HttpClient http;
  late _Core core;

  setUp(() async {
    await AppLocalizations.load(const Locale('en'));
    core = _Core();
    _Outbound.watched.clear();
    _Services.watched.clear();
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
        outboundIpProbeProvider.overrideWith(_Outbound.new),
        providersProvider.overrideWithBuild((_, _) => []),
        ipQualityProvider('192.0.2.5').overrideWith((_) async => const IpQuality(ip: '192.0.2.5', source: IpQualitySource.ipLocate, type: IpType.residential)),
        serviceStatusProvider.overrideWith(_Services.new),
        enabledServiceTargetsProvider.overrideWithValue([ServiceTarget.google]),
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

  test('state includes dashboard history and live counters', () async {
    container
        .read(trafficsProvider.notifier)
        .addTraffic(const Traffic(up: 12, down: 34));
    container.read(requestCountProvider.notifier).value = 7;
    container.read(dnsQueryCountProvider.notifier).value = 4;
    container.read(localIpProvider.notifier).value = '192.0.2.1';
    container.read(runTimeProvider.notifier).value = 123;
    final response = await send('GET', '/api/state');
    final state = response.$2['data'] as Map;
    expect(state['trafficHistory'], [
      {'up': 12, 'down': 34},
    ]);
    expect(state['requestCount'], 7);
    expect(state['dnsQueryCount'], 4);
    expect(state['localIp'], '192.0.2.1');
    expect(state['runTime'], 123);
  });

  test('dashboard combines bounded feeds with applied profile statistics', () async {
    globalState.lastConfigCounts = (groups: 2, proxies: 4, rules: 8);
    addTearDown(() => globalState.lastConfigCounts = null);
    final response = await send('GET', '/api/dashboard');
    expect(response.$1, 200);
    final data = response.$2['data'] as Map;
    expect(data['stats'], {'groups': 2, 'proxies': 4, 'rules': 8, 'providers': 0});
    expect(data['statsFailed'], isFalse);
    expect(data['connections'], isEmpty);
    expect(data['connectionCount'], 0);
    expect(data['memory']['app'], greaterThan(0));
    verifyZeroInteractions(core);
  });

  test('dashboard sessions share subscriptions and release them independently', () async {
    container.read(appVisibleProvider.notifier).value = false;
    for (final session in ['first', 'first', 'second']) {
      expect((await send('POST', '/api/command', {'command': 'watchDashboard', 'session': session, 'shownCount': 1})).$1, 200);
    }
    expect(container.read(remoteProbeClientsProvider), 1);
    expect(container.read(probeActivityProvider), isTrue);
    expect(_Services.watched, {ServiceTarget.google});
    expect(_Outbound.watched, {routedOutbound});
    await send('POST', '/api/command', {'command': 'unwatchDashboard', 'session': 'first'});
    expect(container.read(remoteProbeClientsProvider), 1);
    await send('POST', '/api/command', {'command': 'unwatchDashboard', 'session': 'second'});
    expect(container.read(remoteProbeClientsProvider), 0);
    expect(container.read(probeActivityProvider), isFalse);
    expect(_Services.watched, isEmpty);
    expect(_Outbound.watched, isEmpty);
    verifyZeroInteractions(core);
  });

  test('expired dashboard leases stop keeping service checks alive', () {
    var now = DateTime(2026);
    final watch = DashboardWatch(container, now: () => now);
    addTearDown(watch.dispose);
    watch.renew('abandoned', shownCount: 1);
    expect(_Services.watched, {ServiceTarget.google});
    now = now.add(const Duration(seconds: 21));
    watch.renew('replacement', shownCount: 0);
    expect(_Services.watched, isEmpty);
    watch.remove('replacement');
    expect(_Outbound.watched, isEmpty);
    expect(container.read(remoteProbeClientsProvider), 0);
  });

  test('dashboard refresh commands reject invalid service and address inputs', () async {
    expect((await send('POST', '/api/command', {'command': 'watchDashboard', 'session': 'invalid', 'shownCount': -1})).$1, 400);
    expect((await send('POST', '/api/command', {'command': 'refreshDashboardServices', 'target': 'unknown'})).$1, 400);
    expect((await send('POST', '/api/command', {'command': 'refreshDashboardQuality', 'ip': 'https://example.com'})).$1, 400);
    verifyZeroInteractions(core);
  });

  test('dashboard memory reports desktop RSS while Core is stopped', () async {
    final response = await send('GET', '/api/dashboard/memory');
    expect(response.$1, 200);
    final memory = response.$2['data'] as Map;
    expect(memory['app'], greaterThan(0));
    expect(memory['core'], isNull);
    verifyZeroInteractions(core);
  });

  test('dashboard memory reads the connected Core', () async {
    container.read(coreStatusProvider.notifier).value = CoreStatus.connected;
    when(() => core.getMemoryStats()).thenAnswer(
      (_) async => const CoreMemoryStats(rss: 4096, heapInuse: 2048),
    );
    final response = await send('GET', '/api/dashboard/memory');
    final memory = response.$2['data'] as Map;
    expect(memory['core']['rss'], 4096);
    expect(memory['core']['heapInuse'], 2048);
    verify(() => core.getMemoryStats()).called(1);
  });

  test('dashboard probe states and refreshes use desktop providers', () async {
    _Outbound.refreshes = 0;
    _Services.refreshes = 0;
    final response = await send('GET', '/api/dashboard/probes');
    final data = response.$2['data'] as Map;
    expect(data['outbound']['phase'], 'fresh');
    expect(data['outbound']['value']['ip'], '192.0.2.5');
    final service = (data['services'] as List).single as Map;
    expect(service['id'], 'google');
    expect(service['value']['status'], 'available');
    expect(service['value']['delay'], 42);
    expect(
      (await send('POST', '/api/command', {
        'command': 'refreshDashboardOutbound',
      })).$1,
      200,
    );
    expect(
      (await send('POST', '/api/command', {
        'command': 'refreshDashboardServices',
      })).$1,
      200,
    );
    expect(_Outbound.refreshes, 1);
    expect(_Services.refreshes, 1);
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
