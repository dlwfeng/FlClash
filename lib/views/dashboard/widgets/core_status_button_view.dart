import 'dart:async';
import 'package:fl_clash/enum/core_status.dart';
import 'package:fl_clash/l10n/context.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:material_ui/material_ui.dart';

class CoreStatusButtonView extends StatefulWidget {
  const CoreStatusButtonView({
    super.key,
    required this.status,
    required this.onRestart,
  });
  final CoreStatus status;
  final VoidCallback onRestart;

  @override
  State<CoreStatusButtonView> createState() => _CoreStatusButtonViewState();
}

class _CoreStatusButtonViewState extends State<CoreStatusButtonView> {
  static const _holdDuration = Duration(milliseconds: 600);

  Timer? _holdTimer;
  CoreStatus _status = CoreStatus.disconnected;

  @override
  void initState() {
    super.initState();
    _status = widget.status;
  }

  @override
  void didUpdateWidget(CoreStatusButtonView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status) _onStatusChanged(widget.status);
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }

  void _onStatusChanged(CoreStatus next) {
    setState(() {
      _status = next;
      switch (next) {
        case CoreStatus.connecting:
          _holdTimer ??= Timer(_holdDuration, () {
            if (mounted) {
              setState(() {
                _holdTimer = null;
              });
            }
          });
          break;
        case CoreStatus.disconnected:
          _holdTimer?.cancel();
          _holdTimer = null;
          break;
        case CoreStatus.connected:
          break;
      }
    });
  }

  void _handleConnection() {
    if (_holdTimer == null && widget.status != CoreStatus.connecting)
      widget.onRestart();
  }

  @override
  Widget build(BuildContext context) {
    final coreStatus = _holdTimer != null ? CoreStatus.connecting : _status;
    final appLocalizations = context.appLocalizations;
    final colorScheme = context.colorScheme;
    final glass = TonalButtonTheme.glassOf(context);
    ButtonStyle? tinted(Color? color) => glass && color != null
        ? LiquidGlass.buttonStyle(
            (_) => LiquidGlassStyle.tinted(colorScheme, color),
          )
        : null;
    final statusColor = switch (coreStatus) {
      CoreStatus.connecting => null,
      CoreStatus.connected => colorScheme.successContainer,
      CoreStatus.disconnected => colorScheme.errorContainer,
    };
    final style = ElasticPress.buttonStyle
        .merge(tinted(statusColor))
        .merge(
          FilledButton.styleFrom(
            backgroundColor: statusColor,
            foregroundColor: switch (coreStatus) {
              CoreStatus.connecting => null,
              CoreStatus.connected => colorScheme.onSuccessContainer,
              CoreStatus.disconnected => colorScheme.onErrorContainer,
            },
          ),
        );
    final iconOnly =
        coreStatus == CoreStatus.connected || ViewScope.isMobileOf(context);
    final icon = switch (coreStatus) {
      CoreStatus.connecting => CommonCircleLoading(
        color: iconOnly ? null : colorScheme.onPrimary,
      ),
      CoreStatus.connected => const GlyphIcon(AppGlyphs.check, fill: 1),
      CoreStatus.disconnected => const GlyphIcon(AppGlyphs.refresh, fill: 1),
    };
    return Tooltip(
      message: appLocalizations.coreStatus,
      child: FadeScaleBox(
        alignment: Alignment.centerRight,
        child: iconOnly
            ? IconButton.filled(
                key: ValueKey(coreStatus),
                style: style,
                onPressed: _handleConnection,
                icon: icon,
              )
            : FilledButton.icon(
                key: ValueKey(coreStatus),
                onPressed: _handleConnection,
                style: style,
                icon: SizedBox.square(
                  dimension: MeasureScope.of(
                    context,
                  ).textHeight(AppTextStyle.subheadline),
                  child: icon,
                ),
                label: Text(switch (coreStatus) {
                  CoreStatus.connecting => appLocalizations.connecting,
                  CoreStatus.connected => appLocalizations.connected,
                  CoreStatus.disconnected => appLocalizations.disconnected,
                }),
              ),
      ),
    );
  }
}
