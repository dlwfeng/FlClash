import 'package:fl_clash/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';

bool isMobile(WidgetRef ref, BuildContext context) =>
    ViewScope.isMobileOf(context);
double topOffset(WidgetRef ref, BuildContext context) => pageToolbarHeight;
void logMessage(String text) => debugPrint('message: $text');
