import 'table_widths_source.dart';
import 'package:fl_clash/providers/config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Map<String, double> readWidths(WidgetRef ref, String id) =>
    ref.read(tableWidthsSourceProvider)?.read(id) ?? ref.read(appSettingProvider).tableColumnWidths[id] ?? const {};
void saveWidths(WidgetRef ref, String id, Map<String, double> widths) {
  final source = ref.read(tableWidthsSourceProvider);
  if (source != null) { source.save(id, widths); return; }
  ref.read(appSettingProvider.notifier).update((state) => state.copyWith(
    tableColumnWidths: {...state.tableColumnWidths, id: widths}..removeWhere((_, value) => value.isEmpty)));
}
