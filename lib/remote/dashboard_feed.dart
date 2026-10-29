import 'dart:async';

import 'package:fl_clash/features/connection/feed_bindings.dart';
import 'package:fl_clash/models/feeds.dart';
import 'package:fl_clash/views/connection/connections.dart';
import 'package:fl_clash/views/connection/requests.dart';
import 'package:fl_clash/views/dns_queries.dart';
import 'package:fl_clash/views/dashboard/widgets/connections_table_view.dart';
import 'package:fl_clash/widgets/active_polling.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'client.dart';

class RemoteDashboardFeed extends StatefulWidget {
  const RemoteDashboardFeed({
    super.key,
    required this.client,
    required this.feed,
    required this.controller,
  });
  final RemoteControlClient client;
  final DashboardFeed feed;
  final ScrollController? controller;
  @override
  State<RemoteDashboardFeed> createState() => _RemoteDashboardFeedState();
}

class _RemoteDashboardFeedState extends State<RemoteDashboardFeed>
    with WidgetsBindingObserver, ActivePollingMixin<RemoteDashboardFeed> {
  late final _source = _RemoteFeedSource(widget.client);
  late final _override = feedSourceProvider.overrideWith((_) => _source);
  @override
  Duration get pollInterval => const Duration(seconds: 1);
  @override
  Future<void> poll(PollGuard isCurrent) => _source.refresh();
  @override
  Widget build(BuildContext context) => ProviderScope(
    overrides: [_override],
    child: switch (widget.feed) {
      DashboardFeed.connections => ConnectionsView(
        scrollController: widget.controller,
      ),
      DashboardFeed.requests => RequestsView(
        scrollController: widget.controller,
      ),
      DashboardFeed.dns => DnsQueriesView(scrollController: widget.controller),
    },
  );
}

class _RemoteFeedSource extends FeedSource {
  _RemoteFeedSource(this.client);
  final RemoteControlClient client;
  bool _disposed = false;
  bool _refreshing = false;
  var _revision = 0;
  FeedSnapshot<TrackerInfo> _requests = const FeedSnapshot([], 0);
  FeedSnapshot<DnsQuery> _dns = const FeedSnapshot([], 0);
  @override
  FeedSnapshot<TrackerInfo> get requests => _requests;
  @override
  FeedSnapshot<DnsQuery> get dns => _dns;
  Future<void> refresh() async {
    if (_refreshing || _disposed) return;
    _refreshing = true;
    try {
      final results = await Future.wait([
        client.api('GET', '/api/requests'),
        client.api('GET', '/api/dns'),
      ]);
      if (_disposed) return;
      final requests = results[0] as List;
      final queries = results[1] as List;
      _requests = FeedSnapshot([
        for (final row in requests.whereType<Map>())
          TrackerInfo.fromJson(Map<String, dynamic>.from(row)),
      ], ++_revision);
      _dns = FeedSnapshot([
        for (final row in queries.whereType<Map>())
          DnsQuery.fromJson(Map<String, dynamic>.from(row)),
      ], _revision);
      notifyListeners();
    } finally {
      _refreshing = false;
    }
  }

  @override
  Future<List<TrackerInfo>> getConnections() async {
    final data = await client.api('GET', '/api/connections');
    return [
      for (final row in (data as List).whereType<Map>())
        TrackerInfo.fromJson(Map<String, dynamic>.from(row)),
    ];
  }

  @override
  Future<void> closeConnections() async {
    await client.command('closeConnections');
  }

  @override
  Future<void> closeConnection(String id) async {
    await client.command('closeConnection', {'id': id});
  }

  @override
  Future<bool> clearDnsCache() async =>
      await client.command('clearDnsCache') == true;
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
