import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/service_probe.dart';
import 'package:fl_clash/features/features.dart';
import 'package:fl_clash/providers/outbound_ip.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/providers/routed_probe.dart';
import 'package:fl_clash/providers/service_status.dart';
import 'package:fl_clash/views/dashboard/probe_start_hold.dart';
import 'package:fl_clash/views/dashboard/layout.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'service_status_view.dart';

class ServiceStatusCard extends ConsumerStatefulWidget {
  const ServiceStatusCard({super.key, this.columns = 2});

  final int columns;

  @override
  ConsumerState<ServiceStatusCard> createState() => _ServiceStatusCardState();
}

class _ServiceStatusCardState extends ConsumerState<ServiceStatusCard>
    with ProbeStartHold<ServiceStatusCard> {
  late final ServiceStatus _services;
  Set<ServiceTarget> _shown = const {};
  Set<ServiceTarget> _watched = const {};
  int? _shownCount;
  var _syncScheduled = false;

  @override
  void initState() {
    super.initState();
    _services = ref.read(serviceStatusProvider.notifier);
  }

  @override
  void dispose() {
    for (final target in _watched) {
      _services.unwatch(target);
    }
    super.dispose();
  }

  void _syncShown(Set<ServiceTarget> shown, int count) {
    if (setEquals(shown, _shown) && count == _shownCount) return;
    _shown = shown;
    _shownCount = count;
    if (_syncScheduled) return;
    _syncScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncScheduled = false;
      if (!mounted) return;
      ref.read(shownServiceCountProvider.notifier).value = _shownCount!;
      final shown = _shown;
      for (final target in shown.difference(_watched)) {
        _services.watch(target);
      }
      for (final target in _watched.difference(shown)) {
        _services.unwatch(target);
      }
      _watched = shown;
    });
  }

  @override
  Widget build(BuildContext context) {
    final density = DashboardDensityScope.of(context);
    final mobile = !density.isDesktop;
    // At most four: what the Core checks at once (serviceCheckConcurrency).
    final shownCount = (mobile ? 1 : 2) * widget.columns;
    final shown = ref
        .watch(enabledServiceTargetsProvider)
        .take(shownCount)
        .toList();
    _syncShown(shown.toSet(), shownCount);
    final state = ref.watch(serviceStatusProvider);
    return ServiceStatusCardView(
      columns: widget.columns,
      entries: [
        for (final target in shown)
          serviceCardEntry(
            target,
            state.entryOf(target),
            shownPhase(state.entryOf(target)),
          ),
      ],
      onOpen: () => showServiceStatusSheet(context),
      onRefresh: () => _services.refresh(shown),
    );
  }
}

mixin _NodeAddressWatch<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  late final OutboundIpProbe _ips;
  String? _node;

  @override
  void initState() {
    super.initState();
    _ips = ref.read(outboundIpProbeProvider.notifier);
  }

  @override
  void dispose() {
    _showNode(null);
    super.dispose();
  }

  void _showNode(String? node) {
    final previous = _node;
    if (node == previous) return;
    _node = node;
    if (node != null) _ips.watch(node);
    if (previous != null) _ips.unwatch(previous);
  }
}

Future<void> showServiceStatusSheet(BuildContext context) {
  return showSheet<void>(
    context: context,
    props: nestedPagedSheetProps,
    builder: (_) =>
        NestedPagedSheet(builder: (_) => const ServiceStatusSheet()),
  );
}

/// Every enabled service, read from the cache and checked only on request.
class ServiceStatusSheet extends ConsumerWidget {
  const ServiceStatusSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targets = ref.watch(enabledServiceTargetsProvider);
    final state = ref.watch(serviceStatusProvider);
    final services = ref.read(serviceStatusProvider.notifier);
    return ServiceStatusSheetView(
      targets: targets,
      isLoading: targets.any(state.isLoading),
      onRefresh: () => services.refresh(targets),
      onManage: () => Navigator.of(
        context,
      ).push(PagedSheetRoute(builder: (_) => const ServiceManageView())),
      rowBuilder: (_, target) => _ServiceRow(
        target: target,
        entry: state.entryOf(target),
        onCheck: () => services.refresh([target]),
      ),
    );
  }
}

class ServiceManageView extends ConsumerWidget {
  const ServiceManageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targets = ref.watch(serviceTargetsProvider);
    final enabled = ref.watch(enabledServiceTargetsProvider);
    final settings = ref.read(appSettingProvider.notifier);

    void reorder(int oldIndex, int newIndex) {
      settings.update(
        (state) => state.copyWith(
          serviceOrder: [
            for (final target in targets.copyAndReorder(oldIndex, newIndex))
              target.id,
          ],
        ),
      );
    }

    void toggle(ServiceTarget target, bool value) {
      settings.update((state) {
        final disabled = {...state.disabledServices};
        if (value) {
          disabled.remove(target.id);
        } else {
          disabled.add(target.id);
        }
        return state.copyWith(disabledServices: disabled.toList());
      });
    }

    final shown = enabled.take(ref.watch(shownServiceCountProvider)).toSet();

    return ServiceManagePageView(
      targets: targets,
      enabled: enabled,
      shown: shown,
      onToggle: toggle,
      onReorder: reorder,
    );
  }
}

class _ServiceRow extends ConsumerStatefulWidget {
  const _ServiceRow({
    required this.target,
    required this.entry,
    required this.onCheck,
  });

  final ServiceTarget target;
  final ProbeEntry<ServiceCheck> entry;
  final VoidCallback onCheck;

  @override
  ConsumerState<_ServiceRow> createState() => _ServiceRowState();
}

class _ServiceRowState extends ConsumerState<_ServiceRow>
    with _NodeAddressWatch<_ServiceRow> {
  @override
  Widget build(BuildContext context) {
    final secondary = AppTextStyle.footnote
        .of(context)
        .copyWith(color: context.colorScheme.onSurfaceVariant);
    final target = widget.target;
    final entry = widget.entry;
    final check = entry.value;
    final loading = entry.isLoading;
    final node = check?.node;
    _showNode(node);
    final ipEntry = node != null
        ? ref.watch(
            outboundIpProbeProvider.select((state) => state.entryOf(node)),
          )
        : null;
    final outboundIp = ipEntry?.value;
    final service = serviceCardEntry(target, entry, entry.phase);
    return ServiceRowView(
      service: service,
      loading: loading,
      onCheck: widget.onCheck,
      subtitle: loading
          ? SkeletonText(width: 96, style: secondary)
          : ServiceOutboundIpLineView(
              ip: outboundIp == null
                  ? null
                  : (ip: outboundIp.ip, countryCode: outboundIp.countryCode),
              region: check?.region,
              ipTextBuilder: (ip, style) => IpQualityText(ip: ip, style: style),
              onDetails: (ip) => showIpQualitySheet(context, ip: ip),
              pending:
                  ipEntry != null &&
                  ipEntry.phase != ProbePhase.failed &&
                  outboundIp == null,
              fallback: node,
              style: secondary,
            ),
    );
  }
}

ServiceCardEntry serviceCardEntry(
  ServiceTarget target,
  ProbeEntry<ServiceCheck> entry,
  ProbePhase phase,
) {
  final check = phase == entry.phase ? entry.value : null;
  return ServiceCardEntry(
    target,
    check == null
        ? null
        : ServiceCardCheck(
            status: check.status,
            delay: check.delay,
            node: check.node,
            region: check.region,
          ),
    phase,
  );
}
