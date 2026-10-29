import 'package:fl_clash/enum/message.dart';
import 'package:fl_clash/manager/status_manager.dart';
import 'package:flutter/widgets.dart';
export 'package:fl_clash/enum/message.dart';

void showAppFeedback(
  BuildContext context,
  String text, {
  MessageLevel level = MessageLevel.info,
}) => context.findAncestorStateOfType<StatusManagerState>()?.message(
  text,
  level: level,
);
