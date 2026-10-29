import 'dart:math' as math;
import 'package:fl_clash/enum/dashboard.dart';
import 'package:fl_clash/l10n/context.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:flutter/rendering.dart';
import 'package:material_ui/material_ui.dart';
import 'edit.dart';
import 'layout.dart';
import 'grid.dart';
import 'style.dart';
import 'widgets/table_metrics.dart';

class DashboardPageView extends StatefulWidget {
  const DashboardPageView({
    super.key,
    required this.platform,
    required this.cards,
    required this.mobileCards,
    required this.savedWidgets,
    required this.gap,
    required this.onWidgetsChanged,
    this.statusAction,
  });
  final SupportPlatform platform;
  final DashboardGridCards cards;
  final Map<DashboardWidget, Widget> mobileCards;
  final List<DashboardWidget> savedWidgets;
  final double gap;
  final ValueChanged<List<DashboardWidget>> onWidgetsChanged;
  final Widget? statusAction;

  @override
  State<DashboardPageView> createState() => _DashboardPageViewState();
}

class _DashboardPageViewState extends State<DashboardPageView> {
  var _editing = false;
  final _cardKeys = <DashboardWidget, GlobalKey>{};

  void _setEditing(bool editing) {
    setState(() => _editing = editing);
  }

  GlobalKey _cardKeyOf(DashboardWidget widget) =>
      _cardKeys.putIfAbsent(widget, GlobalKey.new);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => _buildPage(context, constraints.biggest),
  );

  Widget _buildPage(BuildContext context, Size available) {
    final platform = widget.platform;
    final scale = math.max(1.0, MediaQuery.textScalerOf(context).scale(1));
    final editable = !DashboardDensity.of(available / scale).isDesktop;
    if (!editable) _editing = false;
    final editing = _editing;
    final gap = widget.gap;
    final appLocalizations = context.appLocalizations;
    return CommonScaffold(
      backgroundColor: DashboardColors.of(context).page,
      title: editing
          ? appLocalizations.editDashboard
          : appLocalizations.dashboard,
      actions: [if (!editing) ?widget.statusAction],
      confirmationAction: editing
          ? IconButtonData(
              glyph: AppGlyphs.check,
              tooltip: appLocalizations.done,
              onPressed: () => _setEditing(false),
            )
          : null,
      iconActions: [
        if (editable && !editing)
          IconButtonData(
            glyph: AppGlyphs.edit,
            tooltip: appLocalizations.editDashboard,
            onPressed: () => _setEditing(true),
          ),
      ],
      // The providers learn a resize a frame late, too late for the cards.
      body: LayoutBuilder(
        builder: (context, constraints) {
          final room = constraints.biggest / scale;
          final layout = DashboardDensity.of(room);
          return DashboardDensityScope(
            density: layout,
            scale: scale,
            child: layout.isDesktop
                ? DashboardGrid(
                    cards: widget.cards,
                    tablesHeight: connectionsTableMinHeight(layout, scale),
                    columns: dashboardColumnsOf(room.width),
                    gap: gap,
                  )
                : _MobileDashboard(
                    platform: platform,
                    saved: widget.savedWidgets,
                    cards: widget.mobileCards,
                    onWidgetsChanged: widget.onWidgetsChanged,
                    gap: gap,
                    editing: editing,
                    cardKeyOf: _cardKeyOf,
                    onDone: () => _setEditing(false),
                  ),
          );
        },
      ),
    );
  }
}

class _MobileDashboard extends StatelessWidget {
  const _MobileDashboard({
    required this.platform,
    required this.saved,
    required this.cards,
    required this.onWidgetsChanged,
    required this.gap,
    required this.editing,
    required this.cardKeyOf,
    required this.onDone,
  });

  final SupportPlatform platform;
  final List<DashboardWidget> saved;
  final Map<DashboardWidget, Widget> cards;
  final ValueChanged<List<DashboardWidget>> onWidgetsChanged;
  final double gap;
  final bool editing;
  final GlobalKey Function(DashboardWidget widget) cardKeyOf;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final top = context.contentTopPadding;
    final bottom = 16 + context.bottomInset;
    return CustomScrollView(
      // A viewport per card lays them all out and holds the scroll end still.
      scrollCacheExtent: editing
          ? ScrollCacheExtent.viewport(DashboardWidget.values.length.toDouble())
          : null,
      slivers: [
        SliverLayoutBuilder(
          builder: (context, constraints) {
            final side = dashboardMobileSideOf(constraints.crossAxisExtent);
            final widgets = [
              for (final widget in saved)
                if (widget.platforms.contains(platform)) widget,
            ];
            if (editing) {
              return DashboardEditor(
                platform: platform,
                cardBuilder: (item) => cards[item]!,
                onChanged: (shown) => onWidgetsChanged(
                  mergeDashboardWidgets(saved, shown, platform),
                ),
                widgets: widgets,
                cardKeyOf: cardKeyOf,
                padding: EdgeInsets.fromLTRB(side, top, side, bottom),
                gap: gap,
                onDone: onDone,
              );
            }
            return SliverPadding(
              padding: EdgeInsets.fromLTRB(side, top, side, bottom),
              // A lazy list estimates the cards it has not laid out from the
              // ones it has; cards this uneven move the scroll end as it goes.
              sliver: SliverToBoxAdapter(
                child: Column(
                  spacing: gap,
                  children: [
                    for (final widget in widgets)
                      RepaintBoundary(
                        key: cardKeyOf(widget),
                        child: cards[widget]!,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
