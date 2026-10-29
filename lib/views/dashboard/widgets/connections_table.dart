import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/method.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/app.dart';
import 'package:fl_clash/providers/core.dart';
import 'package:fl_clash/views/connection/connections.dart';
import 'package:fl_clash/views/connection/requests.dart';
import 'package:fl_clash/views/dns_queries.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

export 'table_metrics.dart' show connectionsTableTop, connectionsTableMinHeight;
import 'connections_table_view.dart';
export 'connections_table_view.dart' show DashboardFeed;

extension DashboardFeedPage on DashboardFeed {
  PageLabel get page => switch (this) {
    DashboardFeed.connections => PageLabel.connections,
    DashboardFeed.requests => PageLabel.requests,
    DashboardFeed.dns => PageLabel.dns,
  };
}

void openDashboardFeed(BuildContext context, DashboardFeed feed) {
  showSnapSheet(
    context,
    initialScrollOffset: feed == DashboardFeed.connections
        ? 0
        : double.maxFinite,
    builder: (_, controller) => NestedPagedSheet(
      builder: (_) => switch (feed) {
        DashboardFeed.connections => ConnectionsView(
          scrollController: controller,
        ),
        DashboardFeed.requests => RequestsView(scrollController: controller),
        DashboardFeed.dns => DnsQueriesView(scrollController: controller),
      },
    ),
  );
}

/// Polls the live connections while the dashboard is shown: the whole list
/// while its table is open, only the count otherwise.
mixin ConnectionsPolling<T extends ConsumerStatefulWidget>
    on
        ConsumerState<T>,
        WidgetsBindingObserver,
        ActivePollingMixin<T>,
        RouteMotionHoldMixin<T> {
  final connectionCount = ValueNotifier(0);
  List<TrackerInfo> connections = const [];
  var tcpCount = 0;
  var udpCount = 0;

  bool get pollsConnections;

  CoreController get _core => ref.read(coreHandlerProvider);

  @override
  Duration get pollInterval => Duration(seconds: pollsConnections ? 1 : 2);

  @override
  void dispose() {
    connectionCount.dispose();
    super.dispose();
  }

  @override
  Future<void> poll(PollGuard isCurrent) async {
    if (ref.read(coreStatusProvider) != CoreStatus.connected) {
      connectionCount.value = 0;
      if (connections.isNotEmpty && isCurrent()) {
        updateWhenRouteSettled(
          () => setState(() {
            connections = const [];
            tcpCount = 0;
            udpCount = 0;
          }),
        );
      }
      return;
    }
    try {
      if (pollsConnections) {
        final next = [...await _core.getConnections()];
        if (!isCurrent()) return;
        next.sort((a, b) => b.start.compareTo(a.start));
        final tcp = next
            .where((item) => item.metadata.network.toLowerCase() == 'tcp')
            .length;
        connectionCount.value = next.length;
        updateWhenRouteSettled(
          () => setState(() {
            connections = next;
            tcpCount = tcp;
            udpCount = next.length - tcp;
          }),
        );
      } else {
        final count = await _core.getConnectionCount();
        if (!isCurrent()) return;
        connectionCount.value = count;
      }
    } catch (error) {
      commonPrint.log(
        'dashboard connections error: $error',
        logLevel: coreFailureLogLevel(error),
      );
    }
  }
}

/// Follows a counter the Core moves per event, at the cadence the feed's own
/// list repaints at.
class ThrottledCount extends ConsumerStatefulWidget {
  const ThrottledCount({
    super.key,
    required this.provider,
    required this.builder,
  });

  final ProviderListenable<int> provider;
  final Widget Function(BuildContext context, int count) builder;

  @override
  ConsumerState<ThrottledCount> createState() => _ThrottledCountState();
}

class _ThrottledCountState extends ConsumerState<ThrottledCount> {
  late var _count = ref.read(widget.provider);
  late var _latest = _count;
  Timer? _repaint;
  var _active = true;

  @override
  void initState() {
    super.initState();
    ref.listenManual(widget.provider, (_, next) {
      _latest = next;
      if (!_active) {
        return;
      }
      _repaint ??= Timer(renderThrottleDuration, _showLatest);
    });
  }

  void _showLatest() {
    _repaint = null;
    setState(() => _count = _latest);
  }

  // A card can stay deactivated across timer ticks; a repaint there throws.
  @override
  void deactivate() {
    _active = false;
    _repaint?.cancel();
    _repaint = null;
    super.deactivate();
  }

  @override
  void activate() {
    super.activate();
    _active = true;
    _count = _latest;
  }

  @override
  void dispose() {
    _repaint?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _count);
}

class ConnectionsTableCard extends ConsumerStatefulWidget {
  const ConnectionsTableCard({super.key});

  @override
  ConsumerState<ConnectionsTableCard> createState() =>
      _ConnectionsTableCardState();
}

class _ConnectionsTableCardState extends ConsumerState<ConnectionsTableCard>
    with
        WidgetsBindingObserver,
        ActivePollingMixin<ConnectionsTableCard>,
        RouteMotionHoldMixin<ConnectionsTableCard>,
        ConnectionsPolling<ConnectionsTableCard> {
  var _feed = DashboardFeed.connections;
  List<TrackerInfo> _requests = const [];
  List<DnsQuery> _queries = const [];
  Timer? _snapshot;

  @override
  bool get pollsConnections => _feed == DashboardFeed.connections;

  @override
  void initState() {
    super.initState();
    _takeSnapshot();
    ref.listenManual(
      requestsProvider.select((state) => state.revision),
      (_, _) => _scheduleSnapshot(DashboardFeed.requests),
    );
    ref.listenManual(
      dnsQueriesProvider.select((state) => state.revision),
      (_, _) => _scheduleSnapshot(DashboardFeed.dns),
    );
  }

  @override
  void dispose() {
    _snapshot?.cancel();
    super.dispose();
  }

  void _scheduleSnapshot(DashboardFeed feed) {
    if (feed != _feed) return;
    _snapshot ??= Timer(renderThrottleDuration, () {
      _snapshot = null;
      if (mounted) updateWhenRouteSettled(() => setState(_takeSnapshot));
    });
  }

  void _takeSnapshot() {
    switch (_feed) {
      case DashboardFeed.requests:
        _requests = ref.read(requestsProvider).list.reversed.toList();
      case DashboardFeed.dns:
        _queries = ref.read(dnsQueriesProvider).list.reversed.toList();
      case DashboardFeed.connections:
        break;
    }
  }

  void _select(DashboardFeed feed) {
    if (feed == _feed) return;
    setState(() {
      _feed = feed;
      if (feed != DashboardFeed.connections) {
        connections = const [];
      }
      _takeSnapshot();
    });
    if (feed == DashboardFeed.connections) {
      stopPolling();
      startPolling();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: connectionCount,
      builder: (context, count, _) => ThrottledCount(
        provider: requestCountProvider,
        builder: (context, requestsCount) => ThrottledCount(
          provider: dnsQueryCountProvider,
          builder: (context, dnsCount) => ConnectionsTableCardView(
            feed: _feed,
            onSelect: _select,
            connections: connections,
            requests: _requests,
            queries: _queries,
            connectionCount: count,
            requestCount: requestsCount,
            dnsCount: dnsCount,
          ),
        ),
      ),
    );
  }
}
