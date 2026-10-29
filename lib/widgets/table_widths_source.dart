import 'package:flutter_riverpod/flutter_riverpod.dart';
abstract interface class TableWidthsSource {
  Map<String, double> read(String id);
  void save(String id, Map<String, double> widths);
}
final tableWidthsSourceProvider = Provider<TableWidthsSource?>((ref) => null);
