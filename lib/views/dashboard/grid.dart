import 'dart:math' as math;

import 'package:fl_clash/ui/ui.dart';
import 'package:material_ui/material_ui.dart';

import 'layout.dart';

const _servicePairColumnMin = 290.0;
const _maxColumnWidth = 440.0;

class DashboardGridCards {
  const DashboardGridCards({
    required this.outbound,
    required this.upload,
    required this.download,
    required this.mode,
    required this.takeover,
    required this.intranetIp,
    required this.profiles,
    required this.serviceBuilder,
    required this.memory,
    required this.connectionStats,
    required this.proxySummary,
    required this.connections,
    required this.proxyGroups,
  });

  final Widget outbound;
  final Widget upload;
  final Widget download;
  final Widget mode;
  final List<Widget> takeover;
  final Widget intranetIp;
  final Widget profiles;
  final Widget Function(int columns) serviceBuilder;
  final Widget memory;
  final Widget connectionStats;
  final Widget proxySummary;
  final Widget connections;
  final Widget proxyGroups;

  Widget get services => serviceBuilder(2);
}

/// Four columns fill the window, the tables taking what the rows above them
/// leave. A window too short for the tables, and every two column one, gets
/// the summary cards instead, so no list scrolls inside a page that scrolls.
class DashboardGrid extends StatelessWidget {
  const DashboardGrid({
    super.key,
    required this.cards,
    required this.tablesHeight,
    required this.columns,
    required this.gap,
  });

  final DashboardGridCards cards;
  final double tablesHeight;
  final int columns;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final density = DashboardDensityScope.of(context);
    final compact = density.isCompact;
    final scale = DashboardDensityScope.scaleOf(context);
    final base = EdgeInsetsDirectional.fromSTEB(
      16,
      context.contentTopPadding,
      24,
      24 + MediaQuery.paddingOf(context).bottom,
    );
    final topHeight = (compact ? 176 : 208) * scale;
    final controlHeight = (compact ? 56 : 64) * scale;
    final middleHeight = (compact ? 152 : 176) * scale;
    final summaryHeight = (compact ? 112 : 120) * scale;
    return LayoutBuilder(
      builder: (context, constraints) {
        final room =
            constraints.maxWidth - base.horizontal - gap * (columns - 1);
        final column = math.min(room / columns, _maxColumnWidth * scale);
        final inset = (room - column * columns) / 2;
        final padding = base.copyWith(
          start: base.start + inset,
          end: base.end + inset,
        );
        double span(int columns) => column * columns + gap * (columns - 1);
        Widget row(List<(int, Widget)> cards) => Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: gap,
          children: [
            for (final (columns, card) in cards)
              SizedBox(
                width: span(columns),
                child: RepaintBoundary(child: card),
              ),
          ],
        );
        Widget sized(double height, Widget child) =>
            SizedBox(height: height, child: child);
        final switches = [
          for (final tile in cards.takeover)
            (cards.takeover.length == 1 ? 2 : 1, tile),
        ];
        final half = columns ~/ 2;
        final summaries = row([
          (half, cards.connectionStats),
          (half, cards.proxySummary),
        ]);
        if (columns == 2) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: padding,
            child: Column(
              spacing: gap,
              children: [
                sized(topHeight, RepaintBoundary(child: cards.outbound)),
                sized(topHeight, row([(1, cards.upload), (1, cards.download)])),
                sized(controlHeight, RepaintBoundary(child: cards.mode)),
                sized(controlHeight, row(switches)),
                sized(
                  middleHeight,
                  row([(1, cards.intranetIp), (1, cards.profiles)]),
                ),
                sized(
                  middleHeight,
                  row([(1, cards.services), (1, cards.memory)]),
                ),
                sized(summaryHeight, summaries),
              ],
            ),
          );
        }
        final rows = [
          sized(
            topHeight,
            row([(2, cards.outbound), (1, cards.upload), (1, cards.download)]),
          ),
          sized(controlHeight, row([(2, cards.mode), ...switches])),
          sized(
            middleHeight,
            row([
              (1, cards.intranetIp),
              (1, cards.profiles),
              (
                1,
                cards.serviceBuilder(
                  column >= _servicePairColumnMin * scale ? 2 : 1,
                ),
              ),
              (1, cards.memory),
            ]),
          ),
        ];
        final rowsHeight =
            padding.vertical +
            topHeight +
            controlHeight +
            middleHeight +
            gap * 3;
        final tablesFit = constraints.maxHeight >= rowsHeight + tablesHeight;
        final fills = constraints.maxHeight >= rowsHeight + summaryHeight;
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: fills ? constraints.maxHeight : null,
            child: Padding(
              padding: padding,
              child: Column(
                spacing: gap,
                children: [
                  ...rows,
                  if (tablesFit)
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: gap,
                        children: [
                          Expanded(
                            flex: 3,
                            child: RepaintBoundary(child: cards.connections),
                          ),
                          Expanded(
                            flex: 2,
                            child: RepaintBoundary(child: cards.proxyGroups),
                          ),
                        ],
                      ),
                    )
                  else if (fills)
                    Expanded(child: summaries)
                  else
                    sized(summaryHeight, summaries),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
