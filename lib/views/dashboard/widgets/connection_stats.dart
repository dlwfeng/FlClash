import 'package:fl_clash/providers/app.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'connection_stats_view.dart';
import 'connections_table.dart';

/// The counts of the three feeds, each opening its list, for the phone and
/// for a desktop page too short for the table.
class ConnectionStatsCard extends ConsumerStatefulWidget {
  const ConnectionStatsCard({super.key});

  @override
  ConsumerState<ConnectionStatsCard> createState() =>
      _ConnectionStatsCardState();
}

class _ConnectionStatsCardState extends ConsumerState<ConnectionStatsCard>
    with
        WidgetsBindingObserver,
        ActivePollingMixin<ConnectionStatsCard>,
        RouteMotionHoldMixin<ConnectionStatsCard>,
        ConnectionsPolling<ConnectionStatsCard> {
  @override
  bool get pollsConnections => false;

  @override
  Widget build(BuildContext context) {
    return ConnectionStatsCardView(
      onOpen: (feed) => openDashboardFeed(context, feed),
      counts: [
        ValueListenableBuilder(
          valueListenable: connectionCount,
          builder: (_, count, _) => ConnectionCountView(count),
        ),
        ThrottledCount(
          provider: requestCountProvider,
          builder: (_, count) => ConnectionCountView(count),
        ),
        ThrottledCount(
          provider: dnsQueryCountProvider,
          builder: (_, count) => ConnectionCountView(count),
        ),
      ],
    );
  }
}
