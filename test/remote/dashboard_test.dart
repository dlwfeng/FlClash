import 'package:fl_clash/views/dashboard/widgets/connections_table_view.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart';
import 'dart:ui' as ui;
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/service_probe.dart';
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart' as native;
import 'package:fl_clash/providers/outbound_ip.dart';
import 'package:fl_clash/providers/service_status.dart';
import 'package:fl_clash/providers/ip_quality.dart';
import 'package:fl_clash/providers/routed_probe.dart';
import 'package:fl_clash/remote/client.dart';
import 'package:fl_clash/remote/dashboard_page.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/dashboard/dashboard.dart';
import 'package:fl_clash/views/dashboard/widgets/memory_info.dart';
import 'package:fl_clash/views/dashboard/widgets/service_status_view.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import '../helpers/test_app.dart';
import '../helpers/test_profiles.dart';

const _quality = IpQuality(ip: '192.0.2.4', source: IpQualitySource.ipLocate, type: IpType.residential, organization: 'Fixture ISP');
const _memory = MemorySnapshot(app: 8 << 20, coreTotal: 4 << 20, core: CoreMemoryStats(rss: 4 << 20));
const _profile = Profile(id: 1, label: 'Fixture subscription', autoUpdateDuration: Duration.zero, selectedMap: {'Nodes': 'Alpha'});
const _group = Group(name: 'Nodes', type: GroupType.Selector, hidden: false, testUrl: 'https://example.com', all: [Proxy(name: 'Alpha', type: 'ss')]);

class _Core extends Mock implements CoreController {}
class _Ips extends OutboundIpProbe {
  @override
  RoutedProbeState<String, IpInfo> build() => const RoutedProbeState({'': ProbeEntry(phase: ProbePhase.fresh, value: IpInfo(ip: '192.0.2.4', countryCode: 'US'))});
  @override
  void watch(String target) {}
  @override
  void unwatch(String target) {}
}
class _Services extends ServiceStatus {
  @override
  RoutedProbeState<ServiceTarget, ServiceCheck> build() => const RoutedProbeState({
    ServiceTarget.google: ProbeEntry(phase: ProbePhase.fresh, value: ServiceCheck(ServiceProbeStatus.available, delay: 42)),
    ServiceTarget.github: ProbeEntry(phase: ProbePhase.fresh, value: ServiceCheck(ServiceProbeStatus.available, delay: 55)),
  });
  @override
  void watch(ServiceTarget target) {}
  @override
  void unwatch(ServiceTarget target) {}
}
class _Client extends RemoteControlClient {
  _Client() {
    state = {
      'ready': true, 'running': false, 'platform': 'macos', 'coreStatus': 'connected', 'localIp': '192.0.2.5',
      'config': {
        'currentProfileId': 1, 'appSettingProps': const AppSettingProps().toJson(),
        'patchClashConfig': const PatchClashConfig().toJson(), 'networkProps': const NetworkProps().toJson(),
        'proxiesStyleProps': const ProxiesStyleProps().toJson(),
      },
      'profiles': [_profile.toJson()],
      'groups': [_group.toJson()..['all'] = _group.all.map((proxy) => proxy.toJson()).toList()],
      'selectedMap': {'Nodes': 'Alpha'}, 'delays': {},
    };
  }
  final commands = <Map<String, Object?>>[];
  bool fail = false;
  @override
  Future<Object?> api(String method, String path, [Object? body]) async {
    if (fail) throw StateError('fixture offline');
    if (path == '/api/command') { commands.add(Map<String, Object?>.from(body! as Map)); return null; }
    if (path == '/api/dashboard/memory') return {'app': _memory.app, 'core': _memory.core!.toJson()};
    if (path == '/api/dashboard') return {
      'outbound': {'phase': 'fresh', 'value': {'ip': '192.0.2.4', 'countryCode': 'US'}},
      'quality': {'value': _quality.toJson(), 'loading': false},
      'services': [for (final target in [ServiceTarget.google, ServiceTarget.github]) {'id': target.id, 'phase': 'fresh', 'value': {'status': 'available', 'delay': target == ServiceTarget.google ? 42 : 55}}],
      'stats': {'groups': 1, 'proxies': 1, 'rules': 3, 'providers': 0},
      'connections': [], 'requests': [], 'dns': [], 'connectionCount': 0,
    };
    return [];
  }
  @override
  Future<Object?> command(String command, [Map<String, Object?> args = const {}]) async { commands.add({'command': command, ...args}); return null; }
  @override
  Future<Object?> patchSettings(String section, Object? value, Object? expected) async { (state!['config'] as Map)[section] = value; notifyListeners(); return null; }
}

void main() {
  for (final size in [const Size(1200, 824), const Size(800, 900), const Size(412, 900)]) {
    testWidgets('dashboard adapters render identical pixels at $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final core = _Core();
      when(core.getConnections).thenAnswer((_) async => []);
      when(core.getConnectionCount).thenAnswer((_) async => 0);
      final container = ProviderContainer(overrides: [
        native.profilesProvider.overrideWith(() => TestProfiles([_profile])),
        native.currentProfileIdProvider.overrideWithBuild((_, _) => 1),
        native.groupsProvider.overrideWithBuild((_, _) => [_group]),
        native.currentGroupsStateProvider.overrideWithValue(const GroupsState(value: [_group])),
        native.providersProvider.overrideWithBuild((_, _) => []),
        native.localIpProvider.overrideWithBuild((_, _) => '192.0.2.5'),
        native.coreStatusProvider.overrideWithBuild((_, _) => CoreStatus.connected),
        native.coreHandlerProvider.overrideWithValue(core),
        outboundIpProbeProvider.overrideWith(_Ips.new),
        serviceStatusProvider.overrideWith(_Services.new),
        enabledServiceTargetsProvider.overrideWithValue([ServiceTarget.google, ServiceTarget.github]),
        ipQualityProvider('192.0.2.4').overrideWith((_) async => _quality),
      ]);
      addTearDown(container.dispose);
      globalState.container = container;
      globalState.lastConfigCounts = (groups: 1, proxies: 1, rules: 3);
      addTearDown(() => globalState.lastConfigCounts = null);
      container.read(native.viewSizeProvider.notifier).value = size;
      final client = _Client();
      addTearDown(client.dispose);
      const key = ValueKey('dashboard-parity');
      Future<ui.Image> capture(Widget child) async {
        await tester.pumpWidget(UncontrolledProviderScope(container: container, child: TestApp(includeNavigatorKey: false,
          child: RepaintBoundary(key: key, child: child), homeBuilder: (child) => Scaffold(body: child))));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        expect(tester.takeException(), isNull);
        if (find.byType(ConnectionsTableCardView).evaluate().isNotEmpty) {
          final tabs = tester.widgetList<DashboardConnectedButton>(find.descendant(of: find.byType(ConnectionsTableCardView), matching: find.byType(DashboardConnectedButton)));
          expect(tabs.where((tab) => tab.selected), hasLength(1));
        }
        final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(key));
        return (await tester.runAsync(() => boundary.toImage()))!;
      }
      final reference = await capture(DashboardView(platform: SupportPlatform.MacOS, memoryReader: () async => _memory));
      await tester.pumpWidget(const SizedBox());
      final remote = await capture(RemoteDashboardPage(client: client));
      await tester.runAsync(() async {
        final a = (await reference.toByteData())!.buffer.asUint8List();
        final b = (await remote.toByteData())!.buffer.asUint8List();
        expect(b, orderedEquals(a));
      });
      reference.dispose(); remote.dispose();
      await tester.pumpWidget(const SizedBox());
    });
  }
  testWidgets('service sheet uses remote refresh and releases its dashboard lease', (tester) async {
    final client = _Client();
    addTearDown(client.dispose);
    await tester.pumpWidget(ProviderScope(child: TestApp(child: RemoteDashboardPage(client: client), homeBuilder: (child) => Scaffold(body: child))));
    await tester.pump(); await tester.pump(const Duration(seconds: 1));
    await tester.ensureVisible(find.byTooltip('Service status').first);
    await tester.pump();
    await tester.tap(find.byTooltip('Service status').first);
    await tester.pump(); await tester.pump(const Duration(seconds: 1));
    expect(find.byType(ServiceStatusSheetView), findsOneWidget);
    expect(find.text('Google'), findsWidgets);
    await tester.pumpWidget(const SizedBox()); await tester.pump();
    expect(client.commands.any((command) => command['command'] == 'unwatchDashboard'), isTrue);
  });
}
