import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/method.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/feeds.dart';
import 'package:fl_clash/providers/providers.dart' as native;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'feed_bindings.dart';

FeedCore core(Ref ref) =>
    _NativeFeedCore(ref.watch(native.coreHandlerProvider));
FeedSnapshot<TrackerInfo> requests(Ref ref) {
  final value = ref.watch(native.requestsProvider);
  return FeedSnapshot(value.list, value.revision);
}

FeedSnapshot<DnsQuery> dns(Ref ref) {
  final value = ref.watch(native.dnsQueriesProvider);
  return FeedSnapshot(value.list, value.revision);
}

void logFailure(String action, Object error) => commonPrint.log(
  '$action error: $error',
  logLevel: coreFailureLogLevel(error),
);
void showMessage(BuildContext context, String message, bool success) =>
    context.showNotifier(
      message,
      level: success ? MessageLevel.success : MessageLevel.error,
    );

class _NativeFeedCore implements FeedCore {
  _NativeFeedCore(this.core);
  final CoreController core;
  @override
  Future<List<TrackerInfo>> getConnections() => core.getConnections();
  @override
  Future<void> closeConnections() async {
    await core.closeConnections();
  }

  @override
  Future<void> closeConnection(String id) async {
    await core.closeConnection(id);
  }

  @override
  Future<bool> clearDnsCache() => core.clearDnsCache();
}
