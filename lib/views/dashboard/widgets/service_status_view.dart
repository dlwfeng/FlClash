import 'dart:math';
import 'package:fl_clash/common/service_types.dart';
import 'package:fl_clash/enum/probe.dart';
import 'package:fl_clash/l10n/context.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';
import '../layout.dart';
import '../style.dart';
import 'card.dart';

String _statusLabel(BuildContext context, ServiceProbeStatus status) {
  final localizations = context.appLocalizations;
  return switch (status) {
    ServiceProbeStatus.available => localizations.serviceAvailable,
    ServiceProbeStatus.restricted => localizations.serviceRestricted,
    ServiceProbeStatus.unavailable => localizations.serviceUnavailable,
    ServiceProbeStatus.disallowedIsp => localizations.serviceDisallowedIsp,
    ServiceProbeStatus.blocked => localizations.serviceBlocked,
    ServiceProbeStatus.unsupportedRegion =>
      localizations.serviceUnsupportedRegion,
    ServiceProbeStatus.originalsOnly => localizations.serviceOriginalsOnly,
    ServiceProbeStatus.comingSoon => localizations.serviceComingSoon,
    ServiceProbeStatus.timeout => localizations.timeout,
    ServiceProbeStatus.failed => localizations.serviceFailed,
  };
}

Color _statusColor(BuildContext context, ServiceProbeStatus status) {
  final colorScheme = context.colorScheme;
  return switch (status) {
    ServiceProbeStatus.available => colorScheme.success,
    ServiceProbeStatus.restricted ||
    ServiceProbeStatus.disallowedIsp ||
    ServiceProbeStatus.blocked ||
    ServiceProbeStatus.unsupportedRegion ||
    ServiceProbeStatus.originalsOnly ||
    ServiceProbeStatus.comingSoon => colorScheme.warning,
    ServiceProbeStatus.unavailable ||
    ServiceProbeStatus.timeout ||
    ServiceProbeStatus.failed => colorScheme.error,
  };
}

(String, Color) _statusOf(
  BuildContext context,
  ServiceCardCheck? check,
  ProbePhase phase,
) {
  final localizations = context.appLocalizations;
  final idle = context.colorScheme.onSurfaceVariant;
  if (phase == ProbePhase.probing) {
    return (localizations.loading, idle);
  }
  if (check != null) {
    return (
      _statusLabel(context, check.status),
      _statusColor(context, check.status),
    );
  }
  if (phase == ProbePhase.failed) {
    return (
      _statusLabel(context, ServiceProbeStatus.failed),
      context.colorScheme.error,
    );
  }
  return (localizations.servicePending, idle);
}

/// A service as the card shows it: a failure held through a start reads as
/// still checking, without the result it replaced.
class ServiceCardEntry {
  const ServiceCardEntry(this.target, this.check, this.phase);

  final ServiceTarget target;
  final ProbePhase phase;
  final ServiceCardCheck? check;

  bool get loading => phase == ProbePhase.probing && check == null;

  bool get abnormal => switch (check) {
    final check? => check.status != ServiceProbeStatus.available,
    null => phase == ProbePhase.failed,
  };

  (String, Color) statusOf(BuildContext context) => switch (check) {
    ServiceCardCheck(status: ServiceProbeStatus.available, :final delay) => (
      delay != null
          ? '$delay ms'
          : _statusLabel(context, ServiceProbeStatus.available),
      context.colorScheme.onSurfaceVariant,
    ),
    final ServiceCardCheck check => (
      _statusLabel(context, check.status),
      _statusColor(context, check.status),
    ),
    null => _statusOf(context, null, phase),
  };

  Color? dotOf(BuildContext context) => switch (check) {
    final check? => _statusColor(context, check.status),
    null when phase == ProbePhase.failed => context.colorScheme.error,
    null => null,
  };
}

class ServiceCardCheck {
  const ServiceCardCheck({
    required this.status,
    this.delay,
    this.node,
    this.region,
  });
  final ServiceProbeStatus status;
  final int? delay;
  final String? node, region;
}

class ServiceStatusCardView extends StatelessWidget {
  const ServiceStatusCardView({
    super.key,
    this.columns = 2,
    required this.entries,
    required this.onOpen,
    required this.onRefresh,
  });
  final int columns;
  final List<ServiceCardEntry> entries;
  final VoidCallback onOpen, onRefresh;
  @override
  Widget build(BuildContext context) {
    final density = DashboardDensityScope.of(context);
    final mobile = !density.isDesktop;
    final appLocalizations = context.appLocalizations;
    // At most four: what the Core checks at once (serviceCheckConcurrency).
    final shownCount = (mobile ? 1 : 2) * columns;
    final stacked = columns == 1;
    final services = entries.take(shownCount).toList();
    final problems = services.where((service) => service.abnormal).length;
    final verdict = problems > 0
        ? DashboardChip(
            label: appLocalizations.serviceAbnormalCount(problems),
            tone: DashboardChipTone.warn,
          )
        : services.every((service) => service.check != null)
        ? DashboardChip(
            label: appLocalizations.serviceAllAvailable,
            tone: DashboardChipTone.ok,
          )
        : null;
    final openSheet = onOpen;
    final scale = DashboardDensityScope.scaleOf(context);
    final grid = _ServiceGrid(
      services: services,
      columns: columns,
      fill: !mobile,
      cellHeight:
          (mobile
              ? 44
              : density.isCompact
              ? 40
              : 46) *
          scale,
      gap: density.isCompact ? 6 : 8,
    );
    return DashboardCard(
      semanticLabel: appLocalizations.serviceStatus,
      onTap: mobile ? openSheet : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: mobile ? MainAxisSize.min : MainAxisSize.max,
        children: [
          DashboardCardHeader(
            glyph: AppGlyphs.verified,
            title: appLocalizations.serviceStatus,
            chevron: mobile,
            trailing: [
              if (!stacked) ?verdict,
              if (!mobile)
                Transform.translate(
                  offset: const Offset(8, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!stacked)
                        _CheckAllButton(
                          loading: services.any(
                            (entry) => entry.phase == ProbePhase.probing,
                          ),
                          onPressed: onRefresh,
                        ),
                      DashboardIconButton(
                        glyph: AppGlyphs.chevronForward,
                        tooltip: appLocalizations.serviceStatus,
                        onPressed: openSheet,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (mobile) const SizedBox(height: 12) else const Spacer(),
          grid,
        ],
      ),
    );
  }
}

class _ServiceGrid extends StatelessWidget {
  const _ServiceGrid({
    required this.services,
    required this.columns,
    required this.fill,
    required this.cellHeight,
    required this.gap,
  });

  final List<ServiceCardEntry> services;
  final int columns;

  /// Holds two rows on a fixed-height card, a single row growing into tiles.
  final bool fill;
  final double cellHeight;
  final double gap;

  @override
  Widget build(BuildContext context) {
    if (fill && services.length <= columns) {
      return SizedBox(
        height: cellHeight * 2 + gap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: gap,
          children: [
            for (final service in services)
              Expanded(
                child: _ServiceCell(
                  service: service,
                  height: cellHeight,
                  tile: true,
                ),
              ),
          ],
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: gap,
      children: [
        for (var start = 0; start < services.length; start += columns)
          Row(
            spacing: gap,
            children: [
              for (final service in services.skip(start).take(columns))
                Expanded(
                  child: _ServiceCell(service: service, height: cellHeight),
                ),
            ],
          ),
      ],
    );
  }
}

class _ServiceCell extends StatelessWidget {
  const _ServiceCell({
    required this.service,
    required this.height,
    this.tile = false,
  });

  static const _inset = 7.0;

  // Lines the text up with the 12 a cell keeps clear at its end.
  static const _tileText = EdgeInsetsDirectional.fromSTEB(5, 0, 5, 3);

  final ServiceCardEntry service;
  final double height;

  final bool tile;

  @override
  Widget build(BuildContext context) {
    final (label, color) = service.statusOf(context);
    final status = AppTextStyle.caption1
        .of(context, emphasized: true)
        .toTabular
        .copyWith(color: color);
    final badge = _ServiceBadge(
      target: service.target,
      size: height - _inset * 2,
      radius: DashboardCorner.tab - _inset,
      color: DashboardColors.of(context).card,
      ink: context.colorScheme.onSurfaceVariant,
      dot: service.dotOf(context),
    );
    final text = ExcludeSemantics(
      child: service.loading
          ? SkeletonText(width: 44, style: status)
          : Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: status,
            ),
    );
    return Semantics(
      label: service.target.label,
      value: label,
      liveRegion: true,
      child: Tooltip(
        message: '${service.target.label}\n$label',
        excludeFromSemantics: true,
        child: tile
            ? DashboardBlock(
                radius: DashboardCorner.tab,
                padding: const EdgeInsets.all(_inset),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    badge,
                    Padding(padding: _tileText, child: text),
                  ],
                ),
              )
            : SizedBox(
                height: height,
                child: DashboardBlock(
                  radius: DashboardCorner.tab,
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    _inset,
                    0,
                    12,
                    0,
                  ),
                  child: Row(
                    spacing: 8,
                    children: [
                      badge,
                      Expanded(child: text),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class _CheckAllButton extends StatelessWidget {
  const _CheckAllButton({required this.loading, required this.onPressed});

  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const SizedBox.square(
        dimension: 32,
        child: Center(child: CommonCircleLoading(size: 18)),
      );
    }
    return DashboardIconButton(
      glyph: AppGlyphs.bolt,
      tooltip: context.appLocalizations.serviceCheckAll,
      onPressed: onPressed,
    );
  }
}

/// The status dot sits in a notch cleared from the tile rather than on a ring
/// painted in the surface colour, which differs between the card and the rows.
class _ServiceBadge extends StatelessWidget {
  const _ServiceBadge({
    required this.target,
    required this.size,
    this.radius,
    this.dot,
    this.enabled = true,
    this.color,
    this.ink,
  });

  static const _glyphShare = 0.56;

  final ServiceTarget target;
  final double size;
  final double? radius;
  final Color? dot;
  final bool enabled;
  final Color? color;
  final Color? ink;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return CustomPaint(
      size: Size.square(size),
      painter: _BadgePainter(
        color: color ?? context.raisedSurfaceLevel.colorOf(colorScheme),
        radius: radius ?? AppCorner.fit(size),
        dot: dot,
        dotRadius: max(size / 10, 4),
        ring: max(size / 16, 2),
      ),
      child: SizedBox.square(
        dimension: size,
        child: Center(
          child: SvgPicture.asset(
            'assets/images/services/${target.icon}.svg',
            width: size * _glyphShare,
            height: size * _glyphShare,
            excludeFromSemantics: true,
            theme: SvgTheme(
              currentColor:
                  ink ??
                  (enabled
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onSurfaceVariant.opacity38),
            ),
          ),
        ),
      ),
    );
  }
}

class _BadgePainter extends CustomPainter {
  const _BadgePainter({
    required this.color,
    required this.radius,
    required this.dot,
    required this.dotRadius,
    required this.ring,
  });

  final Color color;
  final double radius;
  final Color? dot;
  final double dotRadius;
  final double ring;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    final tile = RSuperellipse.fromRectAndRadius(
      bounds,
      Radius.circular(radius),
    );
    final dot = this.dot;
    if (dot == null) {
      canvas.drawRSuperellipse(tile, Paint()..color = color);
      return;
    }
    final center = size.bottomRight(Offset(-dotRadius, -dotRadius));
    final gap = Path()
      ..addOval(Rect.fromCircle(center: center, radius: dotRadius + ring));
    canvas
      ..drawPath(
        Path.combine(
          PathOperation.difference,
          Path()..addRSuperellipse(tile),
          gap,
        ),
        Paint()..color = color,
      )
      ..drawCircle(center, dotRadius, Paint()..color = dot);
  }

  @override
  bool shouldRepaint(_BadgePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.radius != radius ||
      oldDelegate.dot != dot ||
      oldDelegate.dotRadius != dotRadius ||
      oldDelegate.ring != ring;
}

const _rowBadgeSize = 40.0;
const _rowStatusShare = 0.5;
const _rowBadgeInset = 12.0;
// Concentric with the corners DecorationListItem gives the ends of a run.
const _rowBadgeRadius = AppCorner.xl - _rowBadgeInset;

class ServiceManageItemView extends StatelessWidget {
  const ServiceManageItemView({
    super.key,
    required this.target,
    required this.index,
    required this.position,
    required this.enabled,
    required this.shown,
    required this.onChanged,
  });

  final ServiceTarget target;
  final int index;
  final ItemPosition position;
  final bool enabled;
  final bool shown;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final onChanged = this.onChanged;
    return ReorderableDelayedDragStartListener(
      index: index,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ItemPositionProvider(
          position: position,
          child: DecorationListItem(
            minVerticalPadding: _rowBadgeInset,
            contentPadding: const EdgeInsets.only(
              left: _rowBadgeInset,
              right: 16,
            ),
            onPressed: onChanged == null ? null : () => onChanged(!enabled),
            leading: _ServiceBadge(
              target: target,
              size: _rowBadgeSize,
              radius: _rowBadgeRadius,
              enabled: enabled,
            ),
            title: Text(
              target.label,
              style: enabled
                  ? null
                  : TextStyle(color: context.colorScheme.onSurfaceVariant),
            ),
            subtitle: shown
                ? Text(context.appLocalizations.serviceShownOnDashboard)
                : null,
            trailing: CommonSwitch(value: enabled, onChanged: onChanged),
          ),
        ),
      ),
    );
  }
}

class ServiceRowView extends StatelessWidget {
  const ServiceRowView({
    super.key,
    required this.service,
    required this.loading,
    required this.subtitle,
    required this.onCheck,
  });
  final ServiceCardEntry service;
  final bool loading;
  final Widget subtitle;
  final VoidCallback onCheck;
  @override
  Widget build(BuildContext context) {
    final target = service.target;
    return LayoutBuilder(
      builder: (context, constraints) => DecorationListItem(
        minVerticalPadding: _rowBadgeInset,
        contentPadding: const EdgeInsets.only(left: _rowBadgeInset, right: 16),
        onPressed: loading ? null : onCheck,
        leading: _ServiceBadge(
          target: target,
          size: _rowBadgeSize,
          radius: _rowBadgeRadius,
          dot: loading
              ? context.colorScheme.onSurfaceVariant
              : service.dotOf(context),
        ),
        title: Text(target.label, maxLines: 1, overflow: TextOverflow.ellipsis),
        // A one-line tile is shorter than a two-line one, so the line is always
        // there and a check does not resize the row.
        subtitle: subtitle,
        trailing: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth * _rowStatusShare,
          ),
          child: _ServiceRowStatus(service: service, loading: loading),
        ),
      ),
    );
  }
}

class _ServiceRowStatus extends StatelessWidget {
  const _ServiceRowStatus({required this.service, required this.loading});

  final ServiceCardEntry service;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final (label, color) = service.statusOf(context);
    final style = AppTextStyle.footnote
        .of(context, emphasized: true)
        .toTabular
        .copyWith(color: color);
    if (loading) {
      return SkeletonText(width: 44, style: style);
    }
    return TooltipText(
      text: Text(
        label,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.end,
        style: style,
      ),
    );
  }
}

/// Node names tend to carry their own flag emoji, so a service shows where
/// its traffic leaves from as a flag and the address instead, and falls
/// back to the node only when the address could not be looked up.
class ServiceOutboundIpLineView extends StatelessWidget {
  const ServiceOutboundIpLineView({
    super.key,
    required this.ipTextBuilder,
    required this.onDetails,
    required this.ip,
    required this.region,
    required this.pending,
    required this.fallback,
    required this.style,
  });

  final ({String ip, String? countryCode})? ip;
  final Widget Function(String, TextStyle?) ipTextBuilder;
  final ValueChanged<String> onDetails;
  final String? region;
  final bool pending;
  final String? fallback;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final ip = this.ip;
    final fallback = this.fallback;
    final flag = ip?.countryCode ?? region;
    if (flag == null && ip == null && !pending && fallback == null) {
      return _NoValue(style: style);
    }
    final line = Row(
      spacing: 4,
      children: [
        if (flag != null)
          Text(
            _countryFlag(flag),
            style: style?.copyWith(fontFamily: FontFamily.twEmoji.value),
          ),
        if (ip != null)
          Flexible(child: ipTextBuilder(ip.ip, style))
        else if (pending)
          Flexible(child: SkeletonText(width: 88, style: style))
        else if (fallback != null)
          Flexible(
            child: Text(
              fallback,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
      ],
    );
    if (ip == null) return line;
    return Tooltip(
      message: context.appLocalizations.outboundIp,
      child: InkWell(
        onTap: () => onDetails(ip.ip),
        customBorder: AppShape.xs,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: line,
      ),
    );
  }
}

class _NoValue extends StatelessWidget {
  const _NoValue({this.style});

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Text(
        '—',
        style: style?.copyWith(color: context.colorScheme.onSurfaceVariant),
      ),
    );
  }
}

class ServiceStatusSheetView extends StatelessWidget {
  const ServiceStatusSheetView({
    super.key,
    required this.targets,
    required this.isLoading,
    required this.onRefresh,
    required this.onManage,
    required this.rowBuilder,
  });
  final List<ServiceTarget> targets;
  final bool isLoading;
  final VoidCallback onRefresh, onManage;
  final Widget Function(BuildContext, ServiceTarget) rowBuilder;
  @override
  Widget build(BuildContext context) {
    final localizations = context.appLocalizations;
    return CommonScaffold(
      title: localizations.serviceStatus,
      iconActions: [
        IconButtonData(
          glyph: AppGlyphs.bolt,
          tooltip: localizations.serviceCheckAll,
          isLoading: isLoading,
          onPressed: onRefresh,
        ),
        IconButtonData(
          glyph: AppGlyphs.sliders,
          tooltip: localizations.serviceManage,
          onPressed: onManage,
        ),
      ],
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(height: context.contentTopPadding),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + context.bottomInset),
            sliver: SliverList.builder(
              itemCount: targets.length,
              itemBuilder: (context, index) {
                final target = targets[index];
                return ItemPositionProvider(
                  position: ItemPosition.get(index, targets.length),
                  child: rowBuilder(context, target),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceManagePageView extends StatelessWidget {
  const ServiceManagePageView({
    super.key,
    required this.targets,
    required this.enabled,
    required this.shown,
    required this.onToggle,
    required this.onReorder,
  });
  final List<ServiceTarget> targets, enabled;
  final Set<ServiceTarget> shown;
  final void Function(ServiceTarget, bool) onToggle;
  final void Function(int, int) onReorder;
  @override
  Widget build(BuildContext context) {
    Widget itemAt(int index) {
      final target = targets[index];
      final isEnabled = enabled.contains(target);
      final locked = isEnabled && enabled.length == 1;
      return ServiceManageItemView(
        key: ValueKey(target),
        target: target,
        index: index,
        position: ItemPosition.get(index, targets.length),
        enabled: isEnabled,
        shown: shown.contains(target),
        onChanged: locked ? null : (value) => onToggle(target, value),
      );
    }

    return CommonScaffold(
      title: context.appLocalizations.serviceManage,
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(height: context.contentTopPadding),
          ),
          SliverReorderableList(
            itemBuilder: (_, index) => itemAt(index),
            itemCount: targets.length,
            proxyDecorator: (child, index, animation) =>
                commonProxyDecorator(itemAt(index), index, animation),
            onReorderItem: onReorder,
          ),
          SliverToBoxAdapter(child: SizedBox(height: 16 + context.bottomInset)),
        ],
      ),
    );
  }
}

String _countryFlag(String code) => RegExp(r'^[A-Za-z]{2}$').hasMatch(code) ? String.fromCharCodes(code.toUpperCase().codeUnits.map((unit) => unit + 0x1F1A5)) : code;
