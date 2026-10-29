import 'package:fl_clash/l10n/context.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:material_ui/material_ui.dart';
import '../layout.dart';
import '../style.dart';
import 'card.dart';
import 'connections_table_view.dart';

class ConnectionStatsCardView extends StatelessWidget {
  const ConnectionStatsCardView({
    super.key,
    required this.counts,
    required this.onOpen,
  });
  static const _inset = 8.0;
  final List<Widget> counts;
  final ValueChanged<DashboardFeed> onOpen;
  @override
  Widget build(BuildContext context) {
    final shape = AppShape.all(
      dashboardCardRadius(DashboardDensityScope.of(context)) - _inset,
    );
    return DashboardCard(
      semanticLabel: context.appLocalizations.connectionStats,
      padding: const EdgeInsets.all(_inset),
      child: Row(
        children: [
          _Stat(
            feed: DashboardFeed.connections,
            shape: shape,
            onOpen: onOpen,
            count: counts[0],
          ),
          _Stat(
            feed: DashboardFeed.requests,
            shape: shape,
            onOpen: onOpen,
            count: counts[1],
          ),
          _Stat(
            feed: DashboardFeed.dns,
            shape: shape,
            onOpen: onOpen,
            count: counts[2],
          ),
        ],
      ),
    );
  }
}

class ConnectionCountView extends StatelessWidget {
  const ConnectionCountView(this.count, {super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Text(
      dashboardCount(count),
      maxLines: 1,
      style: DashboardText.figure(
        context,
        AppTextStyle.title2,
      ).copyWith(letterSpacing: 0),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.feed,
    required this.shape,
    required this.count,
    required this.onOpen,
  });

  final DashboardFeed feed;
  final OutlinedBorder shape;
  final Widget count;
  final ValueChanged<DashboardFeed> onOpen;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        button: true,
        label: feed.label,
        child: FocusRing(
          shape: shape,
          child: InkWell(
            customBorder: shape,
            hoverColor: DashboardColors.of(context).tone,
            onTap: () => onOpen(feed),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 2,
                children: [
                  count,
                  Text(
                    feed.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DashboardText.label(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
