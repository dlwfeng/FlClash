import 'package:fl_clash/models/ip_quality.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:material_ui/material_ui.dart';
import 'labels.dart';

class IpQualityTextView extends StatelessWidget {
  const IpQualityTextView({
    super.key,
    required this.ip,
    this.style,
    required this.quality,
    required this.hideIp,
  });

  final String ip;
  final IpQuality? quality;
  final bool hideIp;
  final TextStyle? style;

  static const _mask = '*****';

  @override
  Widget build(BuildContext context) {
    final shownIp = hideIp ? _mask : ip;
    final color = quality?.level.color(context);
    var style = this.style;
    if (hideIp) {
      style = (style ?? const TextStyle()).toJetBrainsMono;
    }
    if (color != null) {
      style = (style ?? const TextStyle()).copyWith(color: color);
    }
    return Tooltip(
      preferBelow: false,
      message: shownIp,
      child: Text(
        shownIp,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
