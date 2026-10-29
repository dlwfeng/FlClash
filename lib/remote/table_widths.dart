import 'dart:async';
import 'package:fl_clash/widgets/table_widths_source.dart';
import 'client.dart';

class RemoteTableWidths implements TableWidthsSource {
  RemoteTableWidths(this.client, this.onError);
  final RemoteControlClient client;
  final void Function(Object) onError;
  Map<String, dynamic> get _settings => Map<String, dynamic>.from((client.state?['config'] as Map?)?['appSettingProps'] as Map? ?? {});
  @override
  Map<String, double> read(String id) {
    final value = (_settings['tableColumnWidths'] as Map?)?[id];
    return value is Map ? {for (final entry in value.entries) if (entry.value is num) '${entry.key}': (entry.value as num).toDouble()} : {};
  }
  @override
  void save(String id, Map<String, double> widths) {
    final previous = _settings;
    final value = {...Map<String, dynamic>.from(previous['tableColumnWidths'] as Map? ?? {}), id: widths}..removeWhere((_, value) => value is Map && value.isEmpty);
    unawaited(client.patchSettings('appSettingProps', {...previous, 'tableColumnWidths': value}, previous).catchError((Object error) { onError(error); return null; }));
  }
}
