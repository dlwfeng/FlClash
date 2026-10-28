import 'dart:math' as math;

import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:material_ui/material_ui.dart';

import '../layout.dart';
import '../style.dart';
import '../format.dart';
import 'card.dart';

const _minSpeedScale = 8 * 1024.0;

const _chartBleed = 3.0;

enum TrafficDirection {
  upload,
  download;

  Glyph get glyph => this == upload ? AppGlyphs.arrowUp : AppGlyphs.arrowDown;

  Color colorOf(BuildContext context) => this == upload
      ? DashboardColors.of(context).series2
      : context.colorScheme.primary;

  Color glyphColorOf(BuildContext context) => this == upload
      ? context.colorScheme.onSurfaceVariant
      : context.colorScheme.primary;

  String labelOf(BuildContext context) => this == upload
      ? AppLocalizations.of(context).upload
      : AppLocalizations.of(context).download;
}

String _speedUnit(({String value, String unit}) show) => '${show.unit}/s';

class _Figure extends StatelessWidget {
  const _Figure({
    required this.show,
    required this.unit,
    required this.style,
    required this.unitStyle,
  });

  final ({String value, String unit}) show;
  final String unit;
  final AppTextStyle style;
  final AppTextStyle unitStyle;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: show.value,
            style: DashboardText.figure(context, style),
          ),
          TextSpan(
            text: ' $unit',
            style: DashboardText.unit(context, unitStyle),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.clip,
    );
  }
}

/// The zero line is the chart's bottom: a card lets the chart bleed past its
/// edge so idle traffic, or none sampled yet, leaves no line.
class _SpeedChart extends StatelessWidget {
  const _SpeedChart({
    required this.direction,
    required this.samples,
    required this.revision,
  });

  final int revision;

  final TrafficDirection direction;
  final List<double> samples;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      values: [...samples],
      revision: revision,
      capacity: 30,
      minScale: _minSpeedScale,
      baselineRatio: 1,
      color: direction.colorOf(context),
    );
  }
}

/// The upload or the download on its own desktop card.
class SpeedCardView extends StatelessWidget {
  const SpeedCardView({
    super.key,
    required this.direction,
    required this.samples,
    required this.total,
    required this.revision,
  });

  final List<double> samples;
  final num total;
  final int revision;

  final TrafficDirection direction;

  @override
  Widget build(BuildContext context) {
    final density = DashboardDensityScope.of(context);
    final compact = density.isCompact;
    final scale = DashboardDensityScope.scaleOf(context);
    final padding = dashboardCardPadding(density);
    final appLocalizations = AppLocalizations.of(context);
    final current = samples.lastOrNull ?? 0;
    final peak = samples.fold<double>(0, math.max);
    final speed = dashboardTrafficValue(current);
    return DashboardCard(
      padding: EdgeInsets.zero,
      semanticLabel: direction.labelOf(context),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            left: -_chartBleed,
            right: -_chartBleed,
            bottom: -_chartBleed,
            height: compact ? 62 : 88,
            child: RepaintBoundary(
              child: _SpeedChart(
                direction: direction,
                samples: samples,
                revision: revision,
              ),
            ),
          ),
          Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24 * scale,
                  child: Row(
                    spacing: 8,
                    children: [
                      GlyphIcon(
                        direction.glyph,
                        size: 18,
                        color: direction.glyphColorOf(context),
                      ),
                      Text(
                        direction.labelOf(context),
                        maxLines: 1,
                        style: DashboardText.cardTitle(context),
                      ),
                      Expanded(
                        child: Text(
                          appLocalizations.trafficPeak(
                            '${dashboardTraffic(peak)}/s',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: DashboardText.label(context),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: compact ? 6 : 10),
                _Figure(
                  show: speed,
                  unit: _speedUnit(speed),
                  style: compact
                      ? AppTextStyle.largeTitle
                      : AppTextStyle.display,
                  unitStyle: AppTextStyle.subheadline,
                ),
                const SizedBox(height: 2),
                Text(
                  appLocalizations.trafficTotal(dashboardTraffic(total)),
                  maxLines: 1,
                  style: DashboardText.label(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The phone's single card: both directions side by side.
class NetworkSpeedCardView extends StatelessWidget {
  const NetworkSpeedCardView({
    super.key,
    required this.uploads,
    required this.downloads,
    required this.totalUp,
    required this.totalDown,
    required this.revision,
  });

  final List<double> uploads;
  final List<double> downloads;
  final num totalUp;
  final num totalDown;
  final int revision;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      semanticLabel: AppLocalizations.of(context).networkSpeed,
      child: Column(
        children: [
          DashboardCardHeader(
            glyph: AppGlyphs.speed,
            title: AppLocalizations.of(context).networkSpeed,
          ),
          const SizedBox(height: 12),
          Row(
            spacing: 10,
            children: [
              for (final direction in TrafficDirection.values)
                Expanded(
                  child: _SpeedTile(
                    direction: direction,
                    speed:
                        (direction == TrafficDirection.upload
                                ? uploads
                                : downloads)
                            .lastOrNull ??
                        0,
                    total: direction == TrafficDirection.upload
                        ? totalUp
                        : totalDown,
                    samples: direction == TrafficDirection.upload
                        ? uploads
                        : downloads,
                    revision: revision,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Keeps one shape at every width: the chart takes the height the tile's
/// aspect ratio leaves under the text, down to [_minChartHeight].
class _SpeedTile extends StatelessWidget {
  const _SpeedTile({
    required this.direction,
    required this.speed,
    required this.total,
    required this.samples,
    required this.revision,
  });

  final TrafficDirection direction;
  final int revision;
  final num speed;
  final num total;
  final List<double> samples;

  static const _aspectRatio = 1.06;
  static const _padding = EdgeInsets.fromLTRB(16, 14, 16, 0);
  static const _titleGap = 4.0;
  static const _chartGap = 12.0;
  static const _bleed = 2.0;
  static const _minChartHeight = 36.0;

  @override
  Widget build(BuildContext context) {
    final color = direction.glyphColorOf(context);
    final show = dashboardTrafficValue(speed);
    final scale = DashboardDensityScope.scaleOf(context);
    final textHeight =
        _padding.top +
        _titleGap +
        (AppTextStyle.footnote.leading +
                AppTextStyle.title1.leading +
                AppTextStyle.caption1.leading) *
            scale;
    return LayoutBuilder(
      builder: (context, constraints) {
        final chartHeight = math.max(
          _minChartHeight,
          constraints.maxWidth / _aspectRatio - textHeight - _chartGap + _bleed,
        );
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: DashboardColors.of(context).tone,
            shape: AppShape.all(DashboardCorner.mobileBlock),
          ),
          child: Stack(
            children: [
              Positioned(
                left: -_bleed,
                right: -_bleed,
                bottom: -_bleed,
                height: chartHeight,
                child: RepaintBoundary(
                  child: _SpeedChart(
                    direction: direction,
                    samples: samples,
                    revision: revision,
                  ),
                ),
              ),
              Padding(
                padding: _padding.copyWith(
                  bottom: chartHeight - _bleed + _chartGap,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 4,
                      children: [
                        GlyphIcon(direction.glyph, size: 16, color: color),
                        Flexible(
                          child: Text(
                            direction.labelOf(context),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.footnote
                                .of(context, emphasized: true)
                                .copyWith(
                                  color: context.colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: _titleGap),
                    _Figure(
                      show: show,
                      unit: _speedUnit(show),
                      style: AppTextStyle.title1,
                      unitStyle: AppTextStyle.footnote,
                    ),
                    Text(
                      AppLocalizations.of(
                        context,
                      ).trafficTotal(dashboardTraffic(total)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DashboardText.label(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
