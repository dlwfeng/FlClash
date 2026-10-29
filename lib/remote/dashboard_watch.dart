import 'dart:async';
import 'package:fl_clash/providers/probe_activity.dart';
import 'package:fl_clash/common/service_probe.dart';
import 'package:fl_clash/providers/outbound_ip.dart';
import 'package:fl_clash/providers/service_status.dart';
import 'package:fl_clash/providers/ip_quality.dart';
import 'package:fl_clash/models/ip_quality.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardWatch {
  DashboardWatch(this.container, {DateTime Function()? now})
    : _now = now ?? DateTime.now;
  final DateTime Function() _now;
  final ProviderContainer container;
  final _sessions =
      <String, ({DateTime expires, int shownCount, bool details})>{};
  final _services = <ServiceTarget>{};
  final _nodes = <String>{};
  final _qualities = <String, ProviderSubscription<AsyncValue<IpQuality>>>{};
  Timer? _expiry;
  bool _attached = false;

  void renew(String session, {int shownCount = 4, bool details = false}) {
    _sessions.removeWhere((_, expires) => expires.expires.isBefore(_now()));
    _sessions[session] = (
      expires: _now().add(const Duration(seconds: 20)),
      shownCount: shownCount,
      details: details,
    );
    _expiry ??= Timer.periodic(const Duration(seconds: 5), (_) => _expire());
    _sync();
  }

  void remove(String session) {
    _sessions.remove(session);
    _sync();
  }

  void _expire() {
    _sessions.removeWhere((_, expires) => expires.expires.isBefore(_now()));
    _sync();
  }

  void _sync() {
    final active = _sessions.isNotEmpty;
    if (active != _attached) {
      _attached = active;
      final activity = container.read(remoteProbeClientsProvider.notifier);
      active ? activity.acquire() : activity.release();
    }
    final count = _sessions.values.fold(
      0,
      (count, lease) => count > lease.shownCount ? count : lease.shownCount,
    );
    final services = _sessions.isEmpty
        ? <ServiceTarget>{}
        : container.read(enabledServiceTargetsProvider).take(count).toSet();
    final probes = container.read(serviceStatusProvider.notifier);
    for (final target in services.difference(_services)) {
      probes.watch(target);
    }
    for (final target in _services.difference(services)) {
      probes.unwatch(target);
    }
    _services
      ..clear()
      ..addAll(services);
    final nodes = <String>{
      if (_sessions.isNotEmpty) routedOutbound,
      if (_sessions.values.any((lease) => lease.details))
        for (final target in container.read(enabledServiceTargetsProvider))
          ?container.read(serviceStatusProvider).valueOf(target)?.node,
    };
    final ips = container.read(outboundIpProbeProvider.notifier);
    for (final node in nodes.difference(_nodes)) {
      ips.watch(node);
    }
    for (final node in _nodes.difference(nodes)) {
      ips.unwatch(node);
    }
    _nodes
      ..clear()
      ..addAll(nodes);
    final addresses = {
      for (final node in nodes)
        if (container.read(outboundIpProbeProvider).valueOf(node)
            case final ip?)
          ip.ip,
    };
    for (final ip in _qualities.keys.toSet().difference(addresses)) {
      _qualities.remove(ip)?.close();
    }
    for (final ip in addresses.difference(_qualities.keys.toSet())) {
      _qualities[ip] = container.listen(ipQualityProvider(ip), (_, _) {});
    }
    if (_sessions.isEmpty) {
      _expiry?.cancel();
      _expiry = null;
    }
  }

  void dispose() {
    _sessions.clear();
    _sync();
  }
}
