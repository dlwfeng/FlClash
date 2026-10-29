import 'package:fl_clash/enum/enum.dart';
export 'package:fl_clash/l10n/context.dart';
import 'package:fl_clash/manager/status_manager.dart';
import 'package:fl_clash/models/state.dart';
import 'package:material_ui/material_ui.dart';

extension AppContextExtension on BuildContext {
  void showNotifier(
    String text, {
    MessageLevel level = MessageLevel.info,
    MessageActionState? actionState,
  }) {
    return findAncestorStateOfType<StatusManagerState>()?.message(
      text,
      level: level,
      actionState: actionState,
    );
  }
}
