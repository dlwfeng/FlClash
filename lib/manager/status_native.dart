import 'package:fl_clash/common/print.dart';
import 'package:fl_clash/providers/app.dart';
import 'package:fl_clash/providers/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';

bool isMobile(WidgetRef ref, BuildContext context) =>
    ref.read(isMobileViewProvider);
double topOffset(WidgetRef ref, BuildContext context) =>
    ref.watch(overlayTopOffsetProvider);
void logMessage(String text) => commonPrint.log('message: $text');
