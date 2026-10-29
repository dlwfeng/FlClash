import 'package:fl_clash/enum/dashboard.dart';
import 'package:fl_clash/providers/config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'widget_registry.dart';

Widget card(DashboardWidget widget) => widget.card;
void save(
  WidgetRef ref,
  List<DashboardWidget> Function(List<DashboardWidget>) update,
) => ref
    .read(appSettingProvider.notifier)
    .update(
      (state) =>
          state.copyWith(dashboardWidgets: update(state.dashboardWidgets)),
    );
