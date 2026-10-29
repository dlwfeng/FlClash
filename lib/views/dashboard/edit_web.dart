import 'package:fl_clash/enum/dashboard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

Widget card(DashboardWidget widget) =>
    throw StateError('Missing dashboard card builder');
void save(
  WidgetRef ref,
  List<DashboardWidget> Function(List<DashboardWidget>) update,
) => throw StateError('Missing dashboard editor action');
