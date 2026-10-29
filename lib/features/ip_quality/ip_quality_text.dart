import 'package:fl_clash/providers/config.dart';
import 'package:fl_clash/providers/ip_quality.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'ip_quality_text_view.dart';

class IpQualityText extends ConsumerWidget {
  const IpQualityText({super.key, required this.ip, this.style});
  final String ip;
  final TextStyle? style;
  @override
  Widget build(BuildContext context, WidgetRef ref) => IpQualityTextView(
    ip: ip,
    style: style,
    quality: ref.watch(ipQualityProvider(ip)).value,
    hideIp: ref.watch(appSettingProvider.select((state) => state.hideIp)),
  );
}
