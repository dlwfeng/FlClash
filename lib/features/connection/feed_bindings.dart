import 'dart:async';
import 'package:fl_clash/models/feeds.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:material_ui/material_ui.dart';
import 'feed_native.dart'
    if (dart.library.js_interop) 'feed_web.dart'
    as platform;

abstract interface class FeedCore {
  Future<List<TrackerInfo>> getConnections();
  Future<void> closeConnections();
  Future<void> closeConnection(String id);
  Future<bool> clearDnsCache();
}

class FeedSnapshot<T> {
  const FeedSnapshot(this.list, this.revision);
  final List<T> list;
  final int revision;
}

abstract class FeedSource extends ChangeNotifier implements FeedCore {
  FeedSnapshot<TrackerInfo> get requests;
  FeedSnapshot<DnsQuery> get dns;
}

final feedSourceProvider = ChangeNotifierProvider<FeedSource?>(
  (ref) => null,
  dependencies: const [],
);
final coreHandlerProvider = Provider<FeedCore>(
  (ref) => ref.watch(feedSourceProvider) ?? platform.core(ref),
  dependencies: [feedSourceProvider],
);
final requestsProvider = Provider<FeedSnapshot<TrackerInfo>>(
  (ref) => ref.watch(feedSourceProvider)?.requests ?? platform.requests(ref),
  dependencies: [feedSourceProvider],
);
final dnsQueriesProvider = Provider<FeedSnapshot<DnsQuery>>(
  (ref) => ref.watch(feedSourceProvider)?.dns ?? platform.dns(ref),
  dependencies: [feedSourceProvider],
);

void logFeedFailure(String action, Object error) =>
    platform.logFailure(action, error);
void showFeedMessage(
  BuildContext context,
  String message, {
  bool success = true,
}) => platform.showMessage(context, message, success);

final feedThrottler = _FeedThrottler();

class _FeedThrottler {
  final _pending = <String, Timer>{};
  void call(String tag, VoidCallback callback, {required Duration duration}) {
    _pending.putIfAbsent(
      tag,
      () => Timer(duration, () {
        _pending.remove(tag);
        callback();
      }),
    );
  }
}
