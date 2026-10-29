import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/core.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'grid.dart';
import 'page_view.dart';
import 'widget_registry.dart';
import 'widgets/core_status_button.dart';
import 'widgets/widgets.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key, this.platform, this.memoryReader});
  final MemoryReader? memoryReader;
  final SupportPlatform? platform;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platform = this.platform ?? SupportPlatform.currentPlatform;
    return DashboardPageView(
      platform: platform,
      cards: DashboardGridCards(
        outbound: const CurrentOutboundCard(),
        upload: const SpeedCard(direction: TrafficDirection.upload),
        download: const SpeedCard(direction: TrafficDirection.download),
        mode: const OutboundModeBar(),
        takeover: DashboardWidget.networkTakeover.platforms.contains(platform)
            ? const [
                NetworkTakeoverTile(TakeoverSwitch.systemProxy),
                NetworkTakeoverTile(TakeoverSwitch.tun),
              ]
            : const [VpnTile()],
        intranetIp: const IntranetIpCard(),
        profiles: const ProfilesCard(),
        serviceBuilder: (columns) => ServiceStatusCard(columns: columns),
        memory: MemoryInfo(memoryReader: memoryReader),
        connectionStats: const ConnectionStatsCard(),
        proxySummary: const ProxyGroupsSummaryCard(),
        connections: const ConnectionsTableCard(),
        proxyGroups: const ProxyGroupsCard(),
      ),
      mobileCards: {for (final item in DashboardWidget.values) item: item == DashboardWidget.memoryInfo ? MemoryInfo(memoryReader: memoryReader) : item.card},
      savedWidgets: ref.watch(
        dashboardStateProvider.select((state) => state.dashboardWidgets),
      ),
      gap: cardSpacingOf(context, ref.watch(viewModeProvider)),
      statusAction: coreLib == null ? const CoreStatusButton() : null,
      onWidgetsChanged: (items) => ref
          .read(appSettingProvider.notifier)
          .update((state) => state.copyWith(dashboardWidgets: items)),
    );
  }
}
