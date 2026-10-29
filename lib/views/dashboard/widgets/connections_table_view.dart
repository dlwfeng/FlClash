import 'package:fl_clash/l10n/context.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/feeds.dart';
import 'package:fl_clash/enum/dns_labels.dart';
import 'package:fl_clash/common/datetime.dart';
import 'package:fl_clash/features/connection/tracker_cells.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/widgets/record_table.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import '../layout.dart';
import '../style.dart';
import 'card.dart';
import 'current_outbound_view.dart';

/// Enough to fill the tallest card several times over; the full feed is a
/// tap away.
const _maxFeedRows = 100;
const _midTableWidth = 620.0;
const _wideTableWidth = 880.0;
const _cellInset = 8.0;
const _tableGap = 12.0;
const _headerHeight = 32.0;

double _tabHeightOf(DashboardDensity density) => density.isCompact ? 32 : 36;

double _rowHeightOf(DashboardDensity density) => density.isCompact ? 32 : 34;

/// Keeps the pill tabs concentric with the card's corners.
double _tabInsetOf(DashboardDensity density) =>
    dashboardCardRadius(density) - _tabHeightOf(density) / 2;

enum DashboardFeed {
  connections,
  requests,
  dns;

  String get label {
    final l = AppLocalizations.current;
    return switch (this) {
      connections => l.liveConnections,
      requests => l.recentRequests,
      dns => l.dnsQueries,
    };
  }
}

class ConnectionsTableCardView extends StatelessWidget {
  const ConnectionsTableCardView({
    super.key,
    required this.feed,
    required this.onSelect,
    required this.connections,
    required this.requests,
    required this.queries,
    required this.connectionCount,
    required this.requestCount,
    required this.dnsCount,
  });
  final DashboardFeed feed;
  final ValueChanged<DashboardFeed> onSelect;
  final List<TrackerInfo> connections, requests;
  final List<DnsQuery> queries;
  final int connectionCount, requestCount, dnsCount;
  @override
  Widget build(BuildContext context) {
    final tcpCount = connections
        .where((item) => item.metadata.network.toLowerCase() == 'tcp')
        .length;
    final udpCount = connections.length - tcpCount;
    final density = DashboardDensityScope.of(context);
    final scale = DashboardDensityScope.scaleOf(context);
    final rowHeight = _rowHeightOf(density) * scale;
    final appLocalizations = context.appLocalizations;
    final headerHeight = _tabHeightOf(density) * scale;
    final tabInset = _tabInsetOf(density);
    final cellStart = dashboardCardPadding(density).left - _cellInset;
    Widget segment(DashboardFeed feed, Widget count) =>
        DashboardConnectedButton(
          selected: this.feed == feed,
          first: feed == DashboardFeed.values.first,
          last: feed == DashboardFeed.values.last,
          outer: headerHeight / 2,
          inner: 8,
          background: DashboardColors.of(context).tone,
          semanticLabel: feed.label,
          onTap: () => onSelect(feed),
          builder: (foreground) => _FeedSegment(
            label: feed.label,
            count: count,
            height: headerHeight,
            foreground: foreground,
          ),
        );
    return DashboardCard(
      semanticLabel: appLocalizations.liveConnections,
      padding: EdgeInsets.fromLTRB(cellStart, tabInset, cellStart, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: headerHeight,
            padding: EdgeInsets.symmetric(horizontal: tabInset - cellStart),
            child: LayoutBuilder(
              builder: (context, constraints) => DashboardCappedRow(
                share: 0.45,
                start: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: DashboardConnectedGroup(
                    children: [
                      segment(
                        DashboardFeed.connections,
                        _TabCount(connectionCount),
                      ),
                      segment(DashboardFeed.requests, _TabCount(requestCount)),
                      segment(DashboardFeed.dns, _TabCount(dnsCount)),
                    ],
                  ),
                ),
                end: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: [
                    if (feed == DashboardFeed.connections &&
                        connections.isNotEmpty &&
                        constraints.maxWidth >= _midTableWidth) ...[
                      DashboardChip(
                        label: 'TCP $tcpCount',
                        tone: DashboardChipTone.idle,
                      ),
                      DashboardChip(
                        label: 'UDP $udpCount',
                        tone: DashboardChipTone.idle,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: _tableGap),
          Expanded(
            child: switch (feed) {
              DashboardFeed.connections => _Table<TrackerInfo>(
                key: const ValueKey(DashboardFeed.connections),
                tableId: 'dashboard.connections',
                items: connections,
                rowHeight: rowHeight,
                columnsOf: (width) => _connectionColumns(context, width),
              ),
              DashboardFeed.requests => _Table<TrackerInfo>(
                key: const ValueKey(DashboardFeed.requests),
                tableId: 'dashboard.requests',
                items: requests,
                rowHeight: rowHeight,
                columnsOf: (_) => _requestColumns(context),
              ),
              DashboardFeed.dns => _Table<DnsQuery>(
                key: const ValueKey(DashboardFeed.dns),
                tableId: 'dashboard.dns',
                items: queries,
                rowHeight: rowHeight,
                columnsOf: (_) => _dnsColumns(context),
              ),
            },
          ),
        ],
      ),
    );
  }
}

class _TabCount extends StatelessWidget {
  const _TabCount(this.count);

  final int count;

  @override
  Widget build(BuildContext context) {
    return Text(
      dashboardCount(count),
      maxLines: 1,
      style: AppTextStyle.subheadline
          .of(context, emphasized: true)
          .toTabular
          .copyWith(color: DefaultTextStyle.of(context).style.color),
    );
  }
}

class _FeedSegment extends StatelessWidget {
  const _FeedSegment({
    required this.label,
    required this.count,
    required this.height,
    required this.foreground,
  });

  final String label;
  final Widget count;
  final double height;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            DefaultTextStyle.merge(
              style: TextStyle(color: foreground),
              child: count,
            ),
            Text(
              label,
              maxLines: 1,
              style: AppTextStyle.footnote
                  .of(context, emphasized: true)
                  .copyWith(color: foreground),
            ),
          ],
        ),
      ),
    );
  }
}

class _Table<T> extends ConsumerStatefulWidget {
  const _Table({
    super.key,
    required this.tableId,
    required this.items,
    required this.rowHeight,
    required this.columnsOf,
  });

  final String tableId;
  final List<T> items;
  final double rowHeight;
  final List<RecordColumn<T>> Function(double width) columnsOf;

  @override
  ConsumerState<_Table<T>> createState() => _TableState<T>();
}

class _TableState<T> extends ConsumerState<_Table<T>>
    with TableColumnWidthsMixin<_Table<T>> {
  final _sorter = RecordSorter<T>();
  RecordSort? _sort;

  @override
  String get tableId => widget.tableId;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final rowHeight = widget.rowHeight;
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = widget.columnsOf(constraints.maxWidth);
        final layouts = [for (final column in columns) column.layout];
        final widths = tableColumnWidths(
          layouts,
          constraints.maxWidth,
          columnWidths,
        );
        final sorted = _sorter.sort(widget.items, columns, _sort);
        final items = sorted.length > _maxFeedRows
            ? sorted.sublist(0, _maxFeedRows)
            : sorted;
        final headerStyle = AppTextStyle.caption1
            .of(context, emphasized: true)
            .copyWith(color: colorScheme.onSurfaceVariant);
        final headerHeight =
            _headerHeight * DashboardDensityScope.scaleOf(context);
        final overflows =
            items.length * rowHeight + 2 > constraints.maxHeight - headerHeight;
        final shape = AppShape.all(DashboardCorner.tableHeader);
        final fill = ShapeDecoration(
          color: DashboardColors.of(context).tone,
          shape: shape,
        );
        final body = ListView.builder(
          padding: const EdgeInsets.only(top: 2),
          itemExtent: rowHeight,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final cells = DefaultTextStyle.merge(
              style: AppTextStyle.footnote.of(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              child: TableCells(
                columns: layouts,
                widths: widths,
                height: rowHeight,
                inset: _cellInset,
                cells: [
                  for (final column in columns) column.cell(context, item),
                ],
              ),
            );
            return index.isOdd
                ? DecoratedBox(decoration: fill, child: cells)
                : cells;
          },
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DecoratedBox(
              decoration: fill,
              child: Material(
                type: MaterialType.transparency,
                shape: shape,
                clipBehavior: Clip.antiAlias,
                child: TableColumnResizer(
                  columns: layouts,
                  widths: widths,
                  onResize: (boundary, delta) =>
                      resizeColumn(layouts, widths, boundary, delta),
                  onResizeEnd: saveColumnWidths,
                  onReset: resetColumnWidths,
                  child: TableCells(
                    columns: layouts,
                    widths: widths,
                    height: headerHeight,
                    inset: 0,
                    cells: [
                      for (final column in columns)
                        RecordHeaderCell(
                          label: column.layout.label,
                          end: column.layout.end,
                          style: headerStyle,
                          inset: _cellInset,
                          descending: _sort?.columnId == column.id
                              ? _sort?.descending
                              : null,
                          onTap: column.sortKey == null
                              ? null
                              : () => setState(
                                  () => _sort = nextRecordSort(_sort, column),
                                ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Text(
                          context.appLocalizations.noData,
                          style: DashboardText.label(context),
                        ),
                      ),
                    )
                  : overflows
                  ? DashboardFadeOut(child: body)
                  : body,
            ),
          ],
        );
      },
    );
  }
}

TextStyle _muted(BuildContext context) =>
    TextStyle(color: context.colorScheme.onSurfaceVariant);

class _Muted extends StatelessWidget {
  const _Muted(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: _muted(context));
  }
}

class _Number extends StatelessWidget {
  const _Number(this.text, {this.muted = false});

  final String text;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFeatures: const [FontFeature.tabularFigures()],
        color: muted ? context.colorScheme.onSurfaceVariant : null,
      ),
    );
  }
}

class _Source extends StatelessWidget {
  const _Source(this.name);

  final String name;

  @override
  Widget build(BuildContext context) {
    final letter = name.characters.firstOrNull ?? '?';
    return Row(
      spacing: 8,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: ShapeDecoration(
            color: DashboardColors.of(context).tone2,
            shape: AppShape.all(7),
          ),
          child: Center(
            child: Text(
              letter,
              style: AppTextStyle.caption2
                  .of(context, emphasized: true)
                  .copyWith(color: context.colorScheme.onSurfaceVariant),
            ),
          ),
        ),
        Flexible(
          child: Text(
            name.isEmpty ? '—' : name,
            style: AppTextStyle.footnote.of(context, emphasized: true),
          ),
        ),
      ],
    );
  }
}

class _Exit extends StatelessWidget {
  const _Exit(this.info);

  final TrackerInfo info;

  @override
  Widget build(BuildContext context) {
    final exit = info.chains.firstOrNull ?? '';
    return EmojiText(
      exit.isEmpty ? '—' : exit,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: isBuiltinOutbound(exit) ? _muted(context) : null,
    );
  }
}

String _timeOf(DateTime time) => time.showTime.trim();

String _ruleKey(TrackerInfo info) =>
    '${info.rule} ${info.rulePayload}'.toLowerCase();

String _exitKey(TrackerInfo info) =>
    (info.chains.firstOrNull ?? '').toLowerCase();

List<RecordColumn<TrackerInfo>> _connectionColumns(
  BuildContext context,
  double width,
) {
  final appLocalizations = context.appLocalizations;
  final mid = width >= _midTableWidth;
  final wide = width >= _wideTableWidth;
  return [
    RecordColumn(
      TableColumn('source', appLocalizations.source, width: wide ? 160 : 140),
      cell: (_, info) => _Source(info.metadata.process),
      sortKey: (info) => info.metadata.process.toLowerCase(),
    ),
    RecordColumn(
      TableColumn('target', appLocalizations.target, flex: wide ? 1.3 : 1),
      cell: (_, info) => TrackerTargetText(info),
      sortKey: (info) => info.title.toLowerCase(),
    ),
    if (mid)
      RecordColumn(
        TableColumn(
          'protocol',
          appLocalizations.protocol,
          width: wide ? 52 : 46,
        ),
        cell: (_, info) => _Muted(info.metadata.network.toUpperCase()),
        sortKey: (info) => info.metadata.network.toLowerCase(),
      ),
    if (wide)
      RecordColumn(
        TableColumn('rule', appLocalizations.rule, flex: 1),
        cell: (_, info) => TrackerRuleText(info),
        sortKey: _ruleKey,
      ),
    RecordColumn(
      TableColumn(
        'exit',
        appLocalizations.outboundExit,
        width: wide ? 120 : 100,
      ),
      cell: (_, info) => _Exit(info),
      sortKey: _exitKey,
    ),
    RecordColumn(
      TableColumn(
        'download',
        appLocalizations.download,
        width: wide ? 80 : 70,
        end: true,
      ),
      cell: (_, info) => _Number(dashboardTraffic(info.download)),
      sortKey: (info) => info.download,
      descendingFirst: true,
    ),
    RecordColumn(
      TableColumn(
        'upload',
        appLocalizations.upload,
        width: wide ? 80 : 70,
        end: true,
      ),
      cell: (_, info) => _Number(dashboardTraffic(info.upload)),
      sortKey: (info) => info.upload,
      descendingFirst: true,
    ),
    if (mid)
      RecordColumn(
        TableColumn(
          'duration',
          appLocalizations.duration,
          width: wide ? 72 : 64,
          end: true,
        ),
        cell: (_, info) => _Number(
          trackerDurationText(DateTime.now().difference(info.start)),
          muted: true,
        ),
        sortKey: (info) => -info.start.microsecondsSinceEpoch,
        descendingFirst: true,
      ),
  ];
}

List<RecordColumn<TrackerInfo>> _requestColumns(BuildContext context) {
  final appLocalizations = context.appLocalizations;
  return [
    RecordColumn(
      TableColumn('time', appLocalizations.time, width: 76),
      cell: (_, info) => _Number(_timeOf(info.start), muted: true),
      sortKey: (info) => info.start,
      descendingFirst: true,
    ),
    RecordColumn(
      TableColumn('source', appLocalizations.source, width: 140),
      cell: (_, info) => _Source(info.metadata.process),
      sortKey: (info) => info.metadata.process.toLowerCase(),
    ),
    RecordColumn(
      TableColumn('target', appLocalizations.target, flex: 1.2),
      cell: (_, info) => TrackerTargetText(info),
      sortKey: (info) => info.title.toLowerCase(),
    ),
    RecordColumn(
      TableColumn('rule', appLocalizations.rule, flex: 1),
      cell: (_, info) => TrackerRuleText(info),
      sortKey: _ruleKey,
    ),
    RecordColumn(
      TableColumn('exit', appLocalizations.outboundExit, width: 100),
      cell: (_, info) => _Exit(info),
      sortKey: _exitKey,
    ),
    RecordColumn(
      TableColumn('traffic', appLocalizations.traffic, width: 64, end: true),
      cell: (_, info) => _Number(dashboardTraffic(info.upload + info.download)),
      sortKey: (info) => info.upload + info.download,
      descendingFirst: true,
    ),
  ];
}

List<RecordColumn<DnsQuery>> _dnsColumns(BuildContext context) {
  final appLocalizations = context.appLocalizations;
  return [
    RecordColumn(
      TableColumn('time', appLocalizations.time, width: 76),
      cell: (_, query) => _Number(_timeOf(query.time), muted: true),
      sortKey: (query) => query.time,
      descendingFirst: true,
    ),
    RecordColumn(
      TableColumn('domain', appLocalizations.domain, flex: 1.3),
      cell: (context, query) => Text(
        query.domain,
        style: AppTextStyle.footnote.of(context, emphasized: true),
      ),
      sortKey: (query) => query.domain.toLowerCase(),
    ),
    RecordColumn(
      TableColumn('type', appLocalizations.ipType, width: 60),
      cell: (_, query) => _Muted(query.type),
      sortKey: (query) => query.type,
    ),
    RecordColumn(
      TableColumn('initiator', appLocalizations.initiatorShort, width: 52),
      cell: (_, query) => _Muted(query.initiator?.label ?? '—'),
      sortKey: (query) => query.initiator?.label ?? '',
    ),
    RecordColumn(
      TableColumn('result', appLocalizations.result, flex: 1),
      cell: (_, query) => _DnsResult(query),
      sortKey: (query) => query.summary.toLowerCase(),
    ),
    RecordColumn(
      TableColumn('elapsed', appLocalizations.elapsed, width: 72, end: true),
      cell: (_, query) => _Number('${query.delay} ms', muted: true),
      sortKey: (query) => query.delay,
      descendingFirst: true,
    ),
  ];
}

class _DnsResult extends StatelessWidget {
  const _DnsResult(this.query);

  final DnsQuery query;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    if (query.error.isNotEmpty) {
      return Text(query.error, style: TextStyle(color: colorScheme.error));
    }
    if (query.hasFailureRcode) {
      return Text(
        query.rcode,
        style: AppTextStyle.footnote
            .of(context, emphasized: true)
            .copyWith(color: DashboardColors.of(context).warn),
      );
    }
    final answer = query.answers.firstOrNull ?? '—';
    return Row(
      children: [
        if (query.cached)
          Container(
            height: 18,
            margin: const EdgeInsetsDirectional.only(end: 6),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: ShapeDecoration(
              color: DashboardColors.of(context).tone,
              shape: AppShape.full,
            ),
            child: Center(
              child: Text(
                context.appLocalizations.cache,
                style: AppTextStyle.caption2
                    .of(context, emphasized: true)
                    .copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ),
          ),
        Flexible(
          child: Text(
            answer,
            style: const TextStyle(
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }
}
