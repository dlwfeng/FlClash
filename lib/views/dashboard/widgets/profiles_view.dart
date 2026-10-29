import 'dart:math' as math;
import 'package:fl_clash/l10n/context.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:material_ui/material_ui.dart';
import '../layout.dart';
import '../style.dart';
import 'card.dart';

class ProfilesCardView extends StatelessWidget {
  const ProfilesCardView({
    super.key,
    required this.profileLabel,
    required this.hasProfile,
    required this.switchable,
    required this.updatedText,
    required this.endText,
    required this.end,
    required this.sync,
    required this.footer,
    required this.onOpen,
    required this.onSwitch,
  });
  final String? profileLabel;
  final bool hasProfile;
  final bool switchable;
  final String? updatedText;
  final String? endText;
  final Widget? end;
  final Widget? sync;
  final Widget footer;
  final VoidCallback onOpen;
  final VoidCallback onSwitch;

  @override
  Widget build(BuildContext context) {
    final end = this.end;
    final density = DashboardDensityScope.of(context);
    final mobile = !density.isDesktop;
    final compact = density.isCompact;
    final appLocalizations = context.appLocalizations;
    final label = DashboardText.label(context);
    final name = mobile || !compact
        ? AppTextStyle.headline
        : AppTextStyle.callout;
    final nameRow = Row(
      children: [
        Flexible(
          child: EmojiText(
            profileLabel ?? appLocalizations.addProfile,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: name.of(context, emphasized: true),
          ),
        ),
        if (hasProfile && switchable)
          SizedBox(
            height: name.leading,
            child: DashboardIconButton(
              glyph: AppGlyphs.swap,
              tooltip: appLocalizations.switchProfile,
              onPressed: onSwitch,
            ),
          ),
      ],
    );
    return DashboardCard(
      semanticLabel: appLocalizations.profile,
      onTap: mobile || !hasProfile ? onOpen : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: mobile ? MainAxisSize.min : MainAxisSize.max,
        children: [
          DashboardCardHeader(
            glyph: AppGlyphs.profiles,
            title: appLocalizations.profile,
            chevron: mobile,
            trailing: [
              if (mobile)
                ?sync
              else
                Transform.translate(
                  offset: const Offset(8, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ?sync,
                      DashboardIconButton(
                        glyph: AppGlyphs.chevronForward,
                        tooltip: appLocalizations.details(
                          appLocalizations.profile,
                        ),
                        onPressed: onOpen,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: mobile ? 12 : 10),
          if (compact && end != null)
            DashboardCappedRow(
              spacing: dashboardProfileRowGap,
              start: nameRow,
              end: end,
            )
          else
            nameRow,
          if (hasProfile && !compact)
            LayoutBuilder(
              builder: (context, constraints) {
                final time = updatedText;
                final updated = time == null
                    ? null
                    : appLocalizations.profileUpdatedAt(time);
                final fits =
                    updated == null ||
                    dashboardProfileTextWidth(context, updated, label) +
                            dashboardProfileRowGap +
                            dashboardProfileTextWidth(
                              context,
                              endText ?? '',
                              label,
                            ) <=
                        constraints.maxWidth;
                return Row(
                  spacing: dashboardProfileRowGap,
                  children: [
                    Expanded(
                      child: Text(
                        (fits ? updated : time) ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: label,
                      ),
                    ),
                    ?end,
                  ],
                );
              },
            ),
          if (hasProfile) ...[
            if (mobile) const SizedBox(height: 14) else const Spacer(),
            footer,
          ],
        ],
      ),
    );
  }
}

const dashboardProfileRowGap = 12.0;
double dashboardProfileTextWidth(
  BuildContext context,
  String text,
  TextStyle style,
) => MeasureScope.of(context).computeTextSize(Text(text, style: style)).width;

typedef ProfileUsage = ({int used, int total, double share});
typedef ProfileStats = ({int groups, int proxies, int rules, int providers});
const _nearlyUsedShare = 0.9;
String _percentOf(double share) => '${(share * 100).round()}%';

class ProfileConfigStatsView extends StatelessWidget {
  const ProfileConfigStatsView({
    super.key,
    required this.stats,
    required this.failed,
    required this.figureStyle,
  });
  final ProfileStats? stats;
  final bool failed;
  final AppTextStyle figureStyle;
  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final figure = DashboardText.figure(
      context,
      figureStyle,
    ).copyWith(letterSpacing: 0);
    final label = DashboardText.label(context);
    Widget item(int? value, String name) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (value != null)
          Text(dashboardCount(value), maxLines: 1, style: figure)
        else if (failed)
          Text('—', maxLines: 1, style: figure)
        else
          SkeletonText(width: figureStyle.size * 1.5, style: figure),
        Text(name, maxLines: 1, style: label),
      ],
    );
    return LayoutBuilder(
      // The minimum width lets spaceBetween spread the row inside FittedBox.
      builder: (context, constraints) => FittedBox(
        fit: BoxFit.scaleDown,
        alignment: AlignmentDirectional.centerStart,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: constraints.maxWidth),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 16,
            children: [
              item(stats?.groups, appLocalizations.proxyGroup),
              item(stats?.proxies, appLocalizations.proxies),
              item(stats?.rules, appLocalizations.rules),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileUsageMeterView extends StatelessWidget {
  const ProfileUsageMeterView({
    super.key,
    required this.usage,
    required this.figure,
    required this.gap,
  });

  final ProfileUsage usage;
  final AppTextStyle figure;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final percent = DashboardText.figure(
              context,
              figure,
            ).copyWith(letterSpacing: 0);
            final unit = DashboardText.unit(context, AppTextStyle.footnote);
            final used = ' ${context.appLocalizations.usedShort}';
            final traffic =
                '${dashboardTraffic(usage.used)} / ${dashboardTraffic(usage.total)}';
            final trafficStyle = AppTextStyle.footnote
                .of(context)
                .toTabular
                .copyWith(color: context.colorScheme.onSurfaceVariant);
            final showUnit =
                dashboardProfileTextWidth(
                      context,
                      _percentOf(usage.share),
                      percent,
                    ) +
                    dashboardProfileTextWidth(context, used, unit) +
                    dashboardProfileRowGap +
                    dashboardProfileTextWidth(context, traffic, trafficStyle) <=
                constraints.maxWidth;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              spacing: dashboardProfileRowGap,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: _percentOf(usage.share), style: percent),
                      if (showUnit) TextSpan(text: used, style: unit),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    traffic,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: trafficStyle,
                  ),
                ),
              ],
            );
          },
        ),
        SizedBox(height: gap),
        SizedBox(
          height: 12,
          child: CustomPaint(
            painter: _WavyProgressPainter(
              value: usage.share,
              active: usage.share >= _nearlyUsedShare
                  ? DashboardColors.of(context).warn
                  : context.colorScheme.primary,
              track: DashboardColors.of(context).tone2,
            ),
          ),
        ),
      ],
    );
  }
}

/// The M3 Expressive wavy linear indicator: a wave up to [value], a gap,
/// then a flat track ending in a stop dot.
class _WavyProgressPainter extends CustomPainter {
  const _WavyProgressPainter({
    required this.value,
    required this.active,
    required this.track,
  });

  static const _stroke = 4.0;
  static const _amplitude = 3.0;
  static const _wavelength = 12.0;
  static const _gap = 6.0;
  static const _stop = 4.0;

  final double value;
  final Color active;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final mid = size.height / 2;
    const start = _stroke / 2;
    final end = size.width - _stroke / 2;
    final split = start + (end - start) * value;
    final paint = Paint()
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    if (value > 0) {
      final wave = Path()..moveTo(start, mid);
      for (var x = start; x <= split; x += 1) {
        wave.lineTo(
          x,
          mid + _amplitude * math.sin((x - start) / _wavelength * 2 * math.pi),
        );
      }
      canvas.drawPath(wave, paint..color = active);
    }
    final trackStart = value > 0 ? split + _gap + _stroke : start;
    if (trackStart < end - _stop) {
      canvas.drawLine(
        Offset(trackStart, mid),
        Offset(end - _stop - _gap, mid),
        paint..color = track,
      );
    }
    if (value < 1) {
      canvas.drawCircle(
        Offset(end - _stop / 2, mid),
        _stop / 2,
        Paint()..color = active,
      );
    }
  }

  @override
  bool shouldRepaint(_WavyProgressPainter oldDelegate) =>
      oldDelegate.value != value ||
      oldDelegate.active != active ||
      oldDelegate.track != track;
}
