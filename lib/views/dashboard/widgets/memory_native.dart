import 'package:material_ui/material_ui.dart';
import 'dart:io';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/method.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/providers/app.dart';
import 'package:fl_clash/providers/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'memory_snapshot.dart';

Future<MemorySnapshot> readSnapshot(WidgetRef ref) async {
  final core = ref.read(coreStatusProvider) == CoreStatus.connected
      ? await ref.read(coreHandlerProvider).getMemoryStats()
      : null;
  return MemorySnapshot.resolve(
    rss: ProcessInfo.currentRss,
    core: core,
    coreInProcess: system.isAndroid,
  );
}

Future<void> requestGc(WidgetRef ref) =>
    ref.read(coreHandlerProvider).requestGc();
void logFailure(String action, Object error) => commonPrint.log(
  '$action error: $error',
  logLevel: coreFailureLogLevel(error),
);

void showMessage(BuildContext context, String message, bool success) =>
    context.showNotifier(
      message,
      level: success ? MessageLevel.success : MessageLevel.error,
    );
