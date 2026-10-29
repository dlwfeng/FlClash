import 'package:fl_clash/widgets/feedback.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'memory_snapshot.dart';

Future<MemorySnapshot> readSnapshot(WidgetRef ref) =>
    throw StateError('Missing remote memory reader');
Future<void> requestGc(WidgetRef ref) =>
    throw StateError('Missing remote GC action');
void logFailure(String action, Object error) {}

void showMessage(BuildContext context, String message, bool success) =>
    showAppFeedback(
      context,
      message,
      level: success ? MessageLevel.success : MessageLevel.error,
    );
