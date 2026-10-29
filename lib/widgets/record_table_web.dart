import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'table_widths_source.dart';
Map<String, double> readWidths(WidgetRef ref, String id) => ref.read(tableWidthsSourceProvider)?.read(id) ?? const {};
void saveWidths(WidgetRef ref, String id, Map<String, double> widths) => ref.read(tableWidthsSourceProvider)?.save(id, widths);
