import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fl_clash/common/datetime.dart';
import 'package:fl_clash/common/proxy_layout.dart';
import 'package:fl_clash/common/service_types.dart';
import 'package:fl_clash/enum/dashboard.dart';
import 'package:fl_clash/enum/probe.dart';
import 'package:fl_clash/enum/ip_quality.dart';
import 'package:fl_clash/enum/core_status.dart';
import 'package:fl_clash/views/dashboard/widgets/core_status_button_view.dart';
import 'package:fl_clash/features/ip_quality/ip_quality_sheet_view.dart';
import 'package:fl_clash/features/ip_quality/ip_quality_text_view.dart';
import 'package:fl_clash/l10n/context.dart';
import 'package:fl_clash/models/feeds.dart';
import 'package:fl_clash/models/ip_quality.dart';
import 'package:fl_clash/models/memory.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/dashboard/grid.dart';
import 'package:fl_clash/views/dashboard/layout.dart';
import 'package:fl_clash/views/dashboard/page_view.dart';
import 'package:fl_clash/views/dashboard/style.dart';
import 'package:fl_clash/views/dashboard/widgets/connection_stats_view.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart';
import 'package:fl_clash/views/dashboard/widgets/connections_table_view.dart';
import 'package:fl_clash/views/dashboard/widgets/current_outbound_view.dart';
import 'package:fl_clash/views/dashboard/widgets/intranet_ip_view.dart';
import 'package:fl_clash/views/dashboard/widgets/memory_info.dart';
import 'package:fl_clash/views/dashboard/widgets/network_takeover_view.dart';
import 'package:fl_clash/views/dashboard/widgets/outbound_mode_view.dart';
import 'package:fl_clash/views/dashboard/widgets/profiles_view.dart';
import 'package:fl_clash/views/dashboard/widgets/proxy_groups_view.dart';
import 'package:fl_clash/views/dashboard/widgets/service_status_view.dart';
import 'package:fl_clash/views/dashboard/widgets/traffic_view.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'client.dart';
import 'package:fl_clash/widgets/feedback.dart';
import 'package:fl_clash/views/dashboard/probe_phase_hold.dart';
import 'dashboard_feed.dart';
import 'proxies.dart';
import 'package:fl_clash/models/subscription.dart';
import 'package:fl_clash/widgets/subscription_info_view.dart';
import 'package:fl_clash/widgets/last_update_time_text.dart';
import 'package:fl_clash/views/profiles/picker_view.dart';
import 'package:fl_clash/views/proxies/provider_item_view.dart';
import 'package:fl_clash/views/dashboard/widgets/profile_detail_view.dart';
import 'package:fl_clash/common/traffic_format.dart';
part 'dashboard_profiles.dart';

Map<String, dynamic> _object(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};
List<Map<String, dynamic>> _objects(Object? value) =>
    value is List ? value.whereType<Map>().map(_object).toList() : [];
int _integer(Object? value) => value is num ? value.toInt() : 0;

class RemoteDashboardPage extends StatefulWidget {
  const RemoteDashboardPage({super.key, required this.client});
  final RemoteControlClient client;
  @override
  State<RemoteDashboardPage> createState() => _RemoteDashboardPageState();
}

class _RemoteDashboardPageState extends State<RemoteDashboardPage>
    with WidgetsBindingObserver {
  final _phaseHold = ProbePhaseHold();
  late bool _proxied = state['running'] == true && state['suspended'] != true;
  final _revision = ValueNotifier<int>(0);
  final _session = '${DateTime.now().microsecondsSinceEpoch}';
  Timer? _poll;
  var _loading = false;
  var _active = true;
  var _snapshot = <String, dynamic>{};
  Object? _failure;
  DashboardFeed _feed = DashboardFeed.connections;
  late final RemoteProxyAdapter _proxies = RemoteProxyAdapter(
    widget.client,
    localizations: () => context.appLocalizations,
    showError: _message,
  );
  RemoteControlClient get client => widget.client;
  Map<String, dynamic> get state => client.state ?? {};
  final _pendingSettings = <String, Map<String, Object?>>{};
  Map<String, dynamic> get config => {
    ..._object(state['config']),
    for (final entry in _pendingSettings.entries)
      entry.key: {..._object(_object(state['config'])[entry.key]), ...entry.value},
  };
  Map<String, dynamic> get app => _object(config['appSettingProps']);
  Map<String, dynamic> get clash => _object(config['patchClashConfig']);
  bool get hideIp => app['hideIp'] == true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    client.addListener(_changed);
    _phaseHold.addListener(_phaseChanged);
    unawaited(_refresh());
    _poll = Timer.periodic(
      const Duration(seconds: 2),
      (_) => unawaited(_refresh()),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _active = state == AppLifecycleState.resumed;
    if (_active) unawaited(_refresh());
  }

  void _phaseChanged() {
    if (mounted) {
      _revision.value++;
      setState(() {});
    }
  }

  void _changed() {
    if (!mounted) return;
    final proxied = state['running'] == true && state['suspended'] != true;
    if (_proxied != proxied) {
      _proxied = proxied;
      _phaseHold.rearm(proxied);
    }
    _phaseChanged();
  }

  Future<void> _refresh() async {
    if (_loading || !_active) return;
    _loading = true;
    try {
      await client.api('POST', '/api/command', {
        'command': 'watchDashboard',
        'session': _session,
        'shownCount': _shownServices,
        'details': _servicesOpen,
      });
      final data = _object(await client.api('GET', '/api/dashboard'));
      if (mounted) {
        setState(() {
          _snapshot = data;
          _failure = null;
        });
        _revision.value++;
      }
    } catch (error) {
      if (mounted) setState(() => _failure = error);
    } finally {
      _loading = false;
    }
  }

  void _message(String message) {
    if (!mounted) return;
    showAppFeedback(context, message, level: MessageLevel.error);
  }

  Future<void> _perform(Future<Object?> Function() operation) async {
    if (client.busy || client.error != null || state['ready'] != true) {
      _message(context.appLocalizations.remoteUnavailable);
      return;
    }
    try {
      final result = await operation();
      if (!mounted) return;
      if (result == false) {
        throw StateError(context.appLocalizations.remoteOperationFailed);
      }
      await _refresh();
    } catch (error) {
      if (!mounted) return;
      _message(
        error is DioException
            ? _object(error.response?.data)['error']?.toString() ?? context.appLocalizations.remoteConnectionLost
            : '$error',
      );
    }
  }

  Future<void> _command(
    String command, [
    Map<String, Object?> args = const {},
  ]) => _perform(() => client.command(command, args));

  Future<void> _setting(String section, String key, Object? value) async {
    if (client.busy || client.error != null || state['ready'] != true) {
      _message(context.appLocalizations.remoteUnavailable);
      return;
    }
    final previous = _object(_object(state['config'])[section]);
    (_pendingSettings[section] ??= {})[key] = value;
    _phaseChanged();
    try {
      await _perform(() => client.patchSettings(section, {...previous, key: value}, previous));
    } finally {
      _pendingSettings[section]?.remove(key);
      if (_pendingSettings[section]?.isEmpty == true) _pendingSettings.remove(section);
      _phaseChanged();
    }
  }

  Future<MemorySnapshot> _memory() async {
    final data = _object(await client.api('GET', '/api/dashboard/memory'));
    final core = data['core'];
    return MemorySnapshot.resolve(
      rss: _integer(data['app']),
      core: core is Map ? CoreMemoryStats.fromJson(_object(core)) : null,
      coreInProcess: state['platform'] == 'android',
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    client.removeListener(_changed);
    _poll?.cancel();
    _proxies.dispose();
    _revision.dispose();
    _phaseHold.dispose();
    final releaseClient = client;
    final session = _session;
    unawaited(Future<void>.microtask(() async {
      await releaseClient.api('POST', '/api/command', {'command': 'unwatchDashboard', 'session': session});
    }).catchError((Object _) {}));
    super.dispose();
  }

  List<ServiceCardEntry> get _services => [
    for (final row in _objects(_snapshot['services']))
      if (ServiceTarget.byId('${row['id']}') case final target?)
        ServiceCardEntry(
          target,
          row['value'] is Map
              ? ServiceCardCheck(
                  status: ServiceProbeStatus.byId(
                    '${_object(row['value'])['status']}',
                  ),
                  delay: _object(row['value'])['delay'] as int?,
                  node:
                      (_object(row['value'])['chains'] as List?)?.firstOrNull
                          as String?,
                  region: _object(row['value'])['region'] as String?,
                )
              : null,
          _phaseHold.shown(
            ProbePhase.values.asNameMap()['${row['phase']}'] ??
                ProbePhase.empty,
          ),
        ),
  ];

  IpQuality? _quality(Map<String, dynamic> state) => state['value'] is Map
      ? IpQuality.fromJson(_object(state['value']))
      : null;

  Future<void> _showQuality(String ip) async {
    Widget sheet(BuildContext context) => ListenableBuilder(
      listenable: client,
      builder: (context, _) => _DashboardSnapshotBuilder(
        owner: this,
        builder: (context) {
          final outbound = _object(_object(_snapshot['outbound'])['value']);
          final node = _objects(
            _object(_snapshot['nodes']).values.toList(),
          ).where((item) => item['ip'] == ip).firstOrNull;
          final quality = _object(
            outbound['ip'] == ip ? _snapshot['quality'] : node?['quality'],
          );
          return IpQualitySheetView(
            ip: ip,
            quality: _quality(quality),
            isLoading: quality['loading'] == true,
            failures: [
              for (final failure in _objects(quality['failures']))
                if (IpQualitySource.values.asNameMap()['${failure['source']}']
                    case final source?)
                  (
                    source: source,
                    status:
                        IpQualitySourceStatus.values
                            .asNameMap()['${failure['status']}'] ??
                        IpQualitySourceStatus.failed,
                  ),
            ],
            hideIp: hideIp,
            onRefresh: () => _command('refreshDashboardQuality', {'ip': ip}),
            onHideIp: (value) => _setting('appSettingProps', 'hideIp', value),
          );
        },
      ),
    );
    if (isSheetPage(context)) {
      await Navigator.of(context).push(PagedSheetRoute<void>(builder: sheet));
    } else {
      await showSheet<void>(context: context, builder: sheet);
    }
  }

  bool _servicesOpen = false;
  Future<void> _showServices() async {
    _servicesOpen = true;
    unawaited(_refresh());
    try {
      await _serviceSheet();
    } finally {
      _servicesOpen = false;
      if (mounted) unawaited(_refresh());
    }
  }

  Future<void> _serviceSheet() => showSheet<void>(
    context: context,
    props: nestedPagedSheetProps,
    builder: (_) => NestedPagedSheet(
      builder: (_) => _DashboardSnapshotBuilder(
        owner: this,
        builder: (context) => ServiceStatusSheetView(
          targets: [for (final entry in _services) entry.target],
          isLoading: _services.any(
            (entry) => entry.phase == ProbePhase.probing,
          ),
          onRefresh: () => _command('refreshDashboardServices'),
          onManage: () => Navigator.of(
            context,
          ).push(PagedSheetRoute<void>(builder: (_) => _serviceManage())),
          rowBuilder: (context, target) {
            final entry = _services.firstWhere(
              (entry) => entry.target == target,
            );
            final node = _object(
              _object(_snapshot['nodes'])[entry.check?.node],
            );
            final secondary = AppTextStyle.footnote
                .of(context)
                .copyWith(color: context.colorScheme.onSurfaceVariant);
            return ServiceRowView(
              service: entry,
              loading: entry.phase == ProbePhase.probing,
              onCheck: () =>
                  _command('refreshDashboardServices', {'target': target.id}),
              subtitle: entry.phase == ProbePhase.probing
                  ? SkeletonText(width: 96, style: secondary)
                  : ServiceOutboundIpLineView(
                      ip: node['ip'] is String
                          ? (
                              ip: node['ip'] as String,
                              countryCode: node['countryCode'] as String?,
                            )
                          : null,
                      region: entry.check?.region,
                      pending: entry.check?.node != null && node.isEmpty,
                      fallback: entry.check?.node,
                      style: secondary,
                      ipTextBuilder: (ip, style) => IpQualityTextView(
                        ip: ip,
                        style: style,
                        quality: _quality(_object(node['quality'])),
                        hideIp: hideIp,
                      ),
                      onDetails: _showQuality,
                    ),
            );
          },
        ),
      ),
    ),
  );

  Widget _serviceManage() => _DashboardSnapshotBuilder(
    owner: this,
    builder: (context) {
      final targets = orderServiceTargets(
        (app['serviceOrder'] as List?)?.cast<String>() ?? [],
      );
      final disabled =
          (app['disabledServices'] as List?)?.cast<String>().toSet() ??
          <String>{};
      var enabled = targets
          .where((target) => !disabled.contains(target.id))
          .toList();
      if (enabled.isEmpty) enabled = targets;
      return ServiceManagePageView(
        targets: targets,
        enabled: enabled,
        shown: enabled.take(_shownServices).toSet(),
        onToggle: (target, enabled) {
          final next = {...disabled};
          enabled ? next.remove(target.id) : next.add(target.id);
          unawaited(
            _setting('appSettingProps', 'disabledServices', next.toList()),
          );
        },
        onReorder: (from, to) {
          final next = [...targets];
          next.insert(to, next.removeAt(from));
          unawaited(
            _setting(
              'appSettingProps',
              'serviceOrder',
              next.map((item) => item.id).toList(),
            ),
          );
        },
      );
    },
  );

  int _shownServices = 4;
  Widget _serviceCard(int columns) => Builder(
    builder: (context) {
      _shownServices =
          (DashboardDensityScope.of(context).isDesktop ? 2 : 1) * columns;
      return ServiceStatusCardView(
        columns: columns,
        entries: _services,
        onOpen: _showServices,
        onRefresh: () => _command('refreshDashboardServices'),
      );
    },
  );

  void _openProxies(String? group) => showSheet<void>(
    context: context,
    builder: (_) =>
        RemoteProxiesPage(client: client, picker: true, initialGroup: group),
  );

  void _openFeed(DashboardFeed feed) => showSnapSheet(
    context,
    initialScrollOffset: feed == DashboardFeed.connections
        ? 0
        : double.maxFinite,
    builder: (_, controller) => NestedPagedSheet(
      builder: (_) => RemoteDashboardFeed(
        client: client,
        feed: feed,
        controller: controller,
      ),
    ),
  );

  void _unsupported(String feature) =>
      _message(context.appLocalizations.remoteFeatureUnavailable(feature));

  Widget _profileCard() => Builder(
    builder: (context) {
      final profiles = _objects(state['profiles']);
      final profile = profiles
          .where((row) => row['id'] == config['currentProfileId'])
          .firstOrNull;
      final l = context.appLocalizations;
      final density = DashboardDensityScope.of(context);
      final mobile = !density.isDesktop;
      final figure = mobile
          ? AppTextStyle.title3
          : density.isCompact
          ? AppTextStyle.callout
          : AppTextStyle.headline;
      final subscription = _object(profile?['subscriptionInfo']);
      final total = _integer(subscription['total']);
      final used =
          _integer(subscription['upload']) + _integer(subscription['download']);
      final expires = _integer(subscription['expire']);
      final expiry = expires > 0
          ? DateTime.fromMillisecondsSinceEpoch(expires * 1000)
          : null;
      final days = expiry == null
          ? 0
          : expiry.difference(DateTime.now()).inDays.clamp(0, 1000000);
      final end = expiry != null
          ? l.profileDaysLeft(days)
          : profile == null
          ? null
          : switch (profile['type']) {
              'url' => l.remote,
              'custom' => l.custom,
              _ => l.local,
            };
      final stats = _object(_snapshot['stats']);
      final labelStyle = DashboardText.label(context);
      final endWidget = end == null
          ? null
          : Text(
              end,
              maxLines: 1,
              style: expiry != null && days <= 7
                  ? labelStyle.copyWith(color: DashboardColors.of(context).warn)
                  : labelStyle,
            );
      return ProfilesCardView(
        profileLabel: profile == null ? null : _profileName(profile),
        hasProfile: profile != null,
        switchable: profiles.length > 1,
        updatedText: DateTime.tryParse(
          '${profile?['lastUpdateDate']}',
        )?.getLastUpdateTimeDesc(context),
        endText: end,
        end: expiry == null || endWidget == null
            ? endWidget
            : Tooltip(
                message: l.profileExpiresIn(expiry.show, days),
                child: endWidget,
              ),
        sync: profile?['type'] == 'url'
            ? DashboardIconButton(
                glyph: AppGlyphs.sync,
                tooltip: l.update,
                onPressed: () =>
                    _command('updateProfile', {'id': profile?['id']}),
              )
            : null,
        footer: total > 0
            ? ProfileUsageMeterView(
                usage: (
                  used: used,
                  total: total,
                  share: (used / total).clamp(0, 1),
                ),
                figure: figure,
                gap: mobile ? 8 : 6,
              )
            : ProfileConfigStatsView(
                stats: stats.isEmpty
                    ? null
                    : (
                        groups: _integer(stats['groups']),
                        proxies: _integer(stats['proxies']),
                        rules: _integer(stats['rules']),
                        providers: _integer(stats['providers']),
                      ),
                failed: _snapshot['statsFailed'] == true || _failure != null,
                figureStyle: figure,
              ),
        onOpen: _openProfile,
        onSwitch: _chooseProfile,
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    final history = _objects(state['trafficHistory']);
    final uploads = [
      for (final traffic in history) _integer(traffic['up']).toDouble(),
    ];
    final downloads = [
      for (final traffic in history) _integer(traffic['down']).toDouble(),
    ];
    final total = _object(state['totalTraffic']);
    final outbound = _object(_snapshot['outbound']);
    final info = _object(outbound['value']);
    final quality = _object(_snapshot['quality']);
    final network = _object(config['networkProps']);
    final port = _integer(clash['mixed-port']);
    final mode =
        DashboardMode.values.asNameMap()['${clash['mode']}'] ??
        DashboardMode.rule;
    void onMode(DashboardMode mode) =>
        unawaited(_setting('patchClashConfig', 'mode', mode.name));
    final outboundCard = CurrentOutboundCardView(
      hasProfile:
          _objects(state['profiles']).isNotEmpty &&
          client.error == null &&
          state['ready'] == true,
      isStart: state['running'] == true,
      suspended: state['suspended'] == true,
      ipInfo: info['ip'] is String
          ? (
              ip: info['ip'] as String,
              countryCode: info['countryCode'] as String?,
            )
          : null,
      failed:
          _phaseHold.shown(
                ProbePhase.values.asNameMap()['${outbound['phase']}'] ??
                    ProbePhase.empty,
              ) ==
              ProbePhase.failed ||
          (_failure != null && info.isEmpty),
      checking:
          _phaseHold.shown(
            ProbePhase.values.asNameMap()['${outbound['phase']}'] ??
                ProbePhase.empty,
          ) ==
          ProbePhase.probing,
      qualityLoading: quality['loading'] == true,
      quality: _quality(quality),
      hideIp: hideIp,
      runTime: _runtime(_integer(state['runTime'])),
      onRefresh: () async {
        await _command('refreshDashboardOutbound');
        if (info['ip'] is String && quality['failed'] == true) {
          await _command('refreshDashboardQuality', {'ip': info['ip']});
        }
      },
      onToggle: () => _command('running', {'value': state['running'] != true}),
      onDetails: _showQuality,
    );
    final intranet = IntranetIpCardView(
      localIp: state['localIp'] as String?,
      allowLan: clash['allow-lan'] == true,
      port: port,
      onChange: (value) => _setting('patchClashConfig', 'allow-lan', value),
      onCopy: (value) async {
        await Clipboard.setData(ClipboardData(text: value));
        if (context.mounted) {
          showAppFeedback(
            context,
            context.appLocalizations.copySuccess,
            level: MessageLevel.success,
          );
        }
      },
    );
    final memory = MemoryInfo(
      memoryReader: _memory,
      onRelease: () async {
        await client.command('gc');
      },
    );
    final stats = ConnectionStatsCardView(
      counts: [
        ConnectionCountView(_integer(_snapshot['connectionCount'])),
        ConnectionCountView(_integer(state['requestCount'])),
        ConnectionCountView(_integer(state['dnsQueryCount'])),
      ],
      onOpen: _openFeed,
    );
    final profiles = _profileCard();
    final connections = ConnectionsTableCardView(
      feed: _feed,
      onSelect: (feed) => setState(() => _feed = feed),
      connections: [
        for (final row in _objects(_snapshot['connections']))
          TrackerInfo.fromJson(row),
      ],
      requests: [
        for (final row in _objects(_snapshot['requests']))
          TrackerInfo.fromJson(row),
      ],
      queries: [
        for (final row in _objects(_snapshot['dns'])) DnsQuery.fromJson(row),
      ],
      connectionCount: _integer(_snapshot['connectionCount']),
      requestCount: _integer(state['requestCount']),
      dnsCount: _integer(state['dnsQueryCount']),
    );
    final platform = switch (state['platform']) {
      'macos' => SupportPlatform.MacOS,
      'windows' => SupportPlatform.Windows,
      _ => SupportPlatform.Linux,
    };
    final saved =
        (app['dashboardWidgets'] as List?)
            ?.map((name) => DashboardWidget.values.asNameMap()['$name'])
            .nonNulls
            .toList() ??
        const [
          DashboardWidget.currentOutbound,
          DashboardWidget.networkSpeed,
          DashboardWidget.outboundMode,
          DashboardWidget.networkTakeover,
          DashboardWidget.intranetIp,
          DashboardWidget.serviceStatus,
          DashboardWidget.profiles,
          DashboardWidget.proxyGroups,
          DashboardWidget.connectionStats,
        ];
    return ProviderScope(
      child: ProxyGroupsScope(
        groups: _proxies.groups,
        selected: {
          for (final group in _proxies.groups)
            group.name: _proxies.selectedName(group.name),
        },
        delays: {
          for (final group in _proxies.groups)
            group.name: _proxies.delay(group.name, group.testUrl),
        },
        connected: state['coreStatus'] == 'connected',
        onOpen: _openProxies,
        child: NetworkTakeoverScope(
          systemProxy: network['systemProxy'] == true,
          tun: _object(clash['tun'])['enable'] == true,
          port: port,
          onChanged: (type, value) => type == TakeoverSwitch.systemProxy
              ? unawaited(_setting('networkProps', 'systemProxy', value))
              : unawaited(
                  _setting('patchClashConfig', 'tun', {
                    ..._object(clash['tun']),
                    'enable': value,
                  }),
                ),
          child: DashboardPageView(
            platform: platform,
            gap: cardSpacingOf(
              context,
              getViewMode(MediaQuery.sizeOf(context).width),
            ),
            statusAction: CoreStatusButtonView(
              status:
                  CoreStatus.values.asNameMap()['${state['coreStatus']}'] ??
                  CoreStatus.disconnected,
              onRestart: () async {
                final l = context.appLocalizations;
                final approved = await showFloatingDialog<bool>(
                  context: context,
                  child: Builder(
                    builder: (context) => CommonDialog(
                      title: l.tip,
                      child: SelectableText.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: state['coreStatus'] == 'connected'
                                  ? l.forceRestartCoreTip
                                  : l.restartCoreTip,
                            ),
                          ],
                        ),
                        style: const TextStyle(overflow: TextOverflow.visible),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(l.cancel),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(l.confirm),
                        ),
                      ],
                    ),
                  ),
                );
                if (approved == true && mounted) await _command('restart');
              },
            ),
            savedWidgets: saved,
            onWidgetsChanged: (widgets) => _setting(
              'appSettingProps',
              'dashboardWidgets',
              widgets.map((item) => item.name).toList(),
            ),
            cards: DashboardGridCards(
              outbound: outboundCard,
              upload: SpeedCardView(
                direction: TrafficDirection.upload,
                samples: uploads,
                total: _integer(total['up']),
                revision: _integer(state['trafficRevision']),
              ),
              download: SpeedCardView(
                direction: TrafficDirection.download,
                samples: downloads,
                total: _integer(total['down']),
                revision: _integer(state['trafficRevision']),
              ),
              mode: OutboundModeBarView(mode: mode, onChanged: onMode),
              takeover: const [
                NetworkTakeoverTileView(TakeoverSwitch.systemProxy),
                NetworkTakeoverTileView(TakeoverSwitch.tun),
              ],
              intranetIp: intranet,
              profiles: profiles,
              serviceBuilder: _serviceCard,
              memory: memory,
              connectionStats: stats,
              proxySummary: const ProxyGroupsSummaryCardView(),
              connections: connections,
              proxyGroups: const ProxyGroupsCardView(),
            ),
            mobileCards: {
              DashboardWidget.currentOutbound: outboundCard,
              DashboardWidget.networkSpeed: NetworkSpeedCardView(
                uploads: uploads,
                downloads: downloads,
                totalUp: _integer(total['up']),
                totalDown: _integer(total['down']),
                revision: _integer(state['trafficRevision']),
              ),
              DashboardWidget.outboundMode: OutboundModeCardView(
                mode: mode,
                onChanged: onMode,
              ),
              DashboardWidget.networkTakeover: const NetworkTakeoverCardView(),
              DashboardWidget.serviceStatus: _serviceCard(2),
              DashboardWidget.profiles: profiles,
              DashboardWidget.proxyGroups: const ProxyGroupsCardView(),
              DashboardWidget.connectionStats: stats,
              DashboardWidget.intranetIp: intranet,
              DashboardWidget.memoryInfo: memory,
            },
          ),
        ),
      ),
    );
  }
}

String _runtime(int milliseconds) {
  final duration = Duration(milliseconds: milliseconds);
  if (duration.inHours > 999) return '999:59:59';
  return '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
}

class _DashboardSnapshotBuilder extends StatelessWidget {
  const _DashboardSnapshotBuilder({required this.owner, required this.builder});
  final _RemoteDashboardPageState owner;
  final WidgetBuilder builder;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: owner._revision,
    builder: (context, _) => builder(context),
  );
}
