import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/views/proxies/proxies.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'proxy_groups_view.dart';
import '../layout.dart';

/// The proxies page stays mounted under the dashboard and filters by the same
/// query, so the sheet searches on its own and hands the page's query back.
Future<void> showProxiesSheet(BuildContext context, {String? groupName}) async {
  final container = ProviderScope.containerOf(context, listen: false);
  if (groupName != null) {
    container
        .read(proxiesActionProvider.notifier)
        .updateCurrentGroupName(groupName);
  }
  final query = queryProvider(QueryTag.proxies);
  final pageQuery = container.read(query);
  container.read(query.notifier).value = '';
  await showSheet<void>(
    context: context,
    builder: (_) => const ProxiesView(picker: true),
  );
  container.read(query.notifier).value = pageQuery;
}

class ProxyGroupsCard extends StatelessWidget {
  const ProxyGroupsCard({super.key});
  @override
  Widget build(BuildContext context) =>
      DashboardDensityScope.of(context).isDesktop
      ? const _GroupsAdapter(child: ProxyGroupsCardView())
      : const ProxyGroupsSummaryCard();
}

class ProxyGroupsSummaryCard extends StatelessWidget {
  const ProxyGroupsSummaryCard({super.key});
  @override
  Widget build(BuildContext context) =>
      const _GroupsAdapter(child: ProxyGroupsSummaryCardView());
}

class _GroupsAdapter extends ConsumerWidget {
  const _GroupsAdapter({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(visibleGroupsStateProvider).value;
    return ProxyGroupsScope(
      groups: groups,
      selected: {
        for (final group in groups)
          group.name: ref.watch(selectedProxyNameProvider(group.name)),
      },
      delays: {
        for (final group in groups)
          group.name: ref.watch(
            delayProvider(proxyName: group.name, testUrl: group.testUrl),
          ),
      },
      connected: ref.watch(coreStatusProvider) == CoreStatus.connected,
      onOpen: (group) => showProxiesSheet(context, groupName: group),
      child: child,
    );
  }
}
