import 'package:fl_clash/widgets/feedback.dart';
import 'package:fl_clash/models/feeds.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'feed_bindings.dart';

FeedCore core(Ref ref) => throw StateError('Missing remote feed source');
FeedSnapshot<TrackerInfo> requests(Ref ref) =>
    throw StateError('Missing remote feed source');
FeedSnapshot<DnsQuery> dns(Ref ref) =>
    throw StateError('Missing remote feed source');
void logFailure(String action, Object error) =>
    debugPrint('$action error: $error');
void showMessage(BuildContext context, String message, bool success) =>
    showAppFeedback(
      context,
      message,
      level: success ? MessageLevel.success : MessageLevel.error,
    );
