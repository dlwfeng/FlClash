import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/service_probe.dart';
import 'package:fl_clash/features/features.dart';
import 'package:fl_clash/providers/ip_quality.dart';
import 'package:fl_clash/providers/outbound_ip.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/providers/routed_probe.dart';
import 'package:fl_clash/views/dashboard/probe_start_hold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'current_outbound_view.dart';
export 'current_outbound_view.dart' show isBuiltinOutbound;

/// The address the proxied traffic leaves by, next to the start button.
class CurrentOutboundCard extends ConsumerStatefulWidget {
  const CurrentOutboundCard({super.key});

  @override
  ConsumerState<CurrentOutboundCard> createState() =>
      _CurrentOutboundCardState();
}

class _CurrentOutboundCardState extends ConsumerState<CurrentOutboundCard>
    with ProbeStartHold<CurrentOutboundCard> {
  late final OutboundIpProbe _probe;

  @override
  void initState() {
    super.initState();
    _probe = ref.read(outboundIpProbeProvider.notifier)..watch(routedOutbound);
  }

  @override
  void dispose() {
    _probe.unwatch(routedOutbound);
    super.dispose();
  }

  void _refresh(String? ip) {
    _probe.refresh(const [routedOutbound]);
    if (ip != null && ref.read(ipQualityProvider(ip)).hasError) {
      ref.invalidate(ipQualityProvider(ip));
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasProfile = ref.watch(
      profilesProvider.select((state) => state.isNotEmpty),
    );
    final isStart = ref.watch(isStartProvider);
    final suspended = isStart && ref.watch(suspendProvider);
    final entry = ref.watch(
      outboundIpProbeProvider.select((state) => state.entryOf(routedOutbound)),
    );
    final ipInfo = entry.value;
    final phase = shownPhase(entry);
    final failed = phase == ProbePhase.failed && ipInfo == null;
    final qualityState = ipInfo == null
        ? null
        : ref.watch(ipQualityProvider(ipInfo.ip));
    final quality = qualityState?.value;
    final qualityLoading =
        qualityState != null && quality == null && qualityState.isLoading;
    return CurrentOutboundCardView(
      hasProfile: hasProfile,
      isStart: isStart,
      suspended: suspended,
      ipInfo: ipInfo == null
          ? null
          : (ip: ipInfo.ip, countryCode: ipInfo.countryCode),
      failed: failed,
      checking: phase == ProbePhase.probing,
      qualityLoading: qualityLoading,
      quality: quality,
      hideIp: ref.watch(appSettingProvider.select((state) => state.hideIp)),
      runTime: getTimeText(ref.watch(runTimeProvider)),
      onRefresh: () => _refresh(ipInfo?.ip),
      onToggle: () => ref.read(commonActionProvider.notifier).toggleRunning(),
      onDetails: (ip) => showIpQualitySheet(context, ip: ip),
    );
  }
}
