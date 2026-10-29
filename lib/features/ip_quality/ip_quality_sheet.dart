import 'package:fl_clash/common/ip_quality.dart';
import 'package:fl_clash/providers/config.dart';
import 'package:fl_clash/providers/ip_quality.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'ip_quality_sheet_view.dart';

Future<void> showIpQualitySheet(BuildContext context, {required String ip}) {
  if (isSheetPage(context)) {
    return Navigator.of(
      context,
    ).push(PagedSheetRoute(builder: (_) => _IpQualitySheet(ip: ip)));
  }
  return showSheet<void>(
    context: context,
    builder: (_) => _IpQualitySheet(ip: ip),
  );
}

class _IpQualitySheet extends ConsumerWidget {
  const _IpQualitySheet({required this.ip});
  final String ip;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(ipQualityProvider(ip));
    final error = result.error;
    return IpQualitySheetView(
      ip: ip,
      quality: result.value,
      isLoading: result.isLoading,
      failures: error is IpQualityLookupException ? error.failures : const [],
      hideIp: ref.watch(appSettingProvider.select((state) => state.hideIp)),
      onRefresh: () => ref.invalidate(ipQualityProvider(ip)),
      onHideIp: (value) => ref
          .read(appSettingProvider.notifier)
          .update((state) => state.copyWith(hideIp: value)),
    );
  }
}
