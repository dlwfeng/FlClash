import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/views/dashboard/layout.dart';
import 'package:fl_clash/views/dashboard/style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_new_shapes/material_new_shapes.dart';
import 'package:material_ui/material_ui.dart';

import 'card.dart';
import 'network_takeover_view.dart';
export 'network_takeover_view.dart' show TakeoverSwitch;

class _TakeoverAdapter extends ConsumerWidget {
  const _TakeoverAdapter({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final systemProxy = ref.watch(
      networkSettingProvider.select((state) => state.systemProxy),
    );
    final tun = ref.watch(
      patchClashConfigProvider.select((state) => state.tun.enable),
    );
    final port = ref.watch(
      patchClashConfigProvider.select((state) => state.mixedPort),
    );
    void change(TakeoverSwitch kind, bool value) {
      if (kind == TakeoverSwitch.systemProxy) {
        ref
            .read(networkSettingProvider.notifier)
            .update((state) => state.copyWith(systemProxy: value));
      } else {
        ref
            .read(patchClashConfigProvider.notifier)
            .update((state) => state.copyWith.tun(enable: value));
      }
    }

    return NetworkTakeoverScope(
      systemProxy: systemProxy,
      tun: tun,
      port: port,
      onChanged: change,
      child: child,
    );
  }
}

class NetworkTakeoverCard extends StatelessWidget {
  const NetworkTakeoverCard({super.key});
  @override
  Widget build(BuildContext context) =>
      const _TakeoverAdapter(child: NetworkTakeoverCardView());
}

class NetworkTakeoverTile extends StatelessWidget {
  const NetworkTakeoverTile(this.kind, {super.key});
  final TakeoverSwitch kind;
  @override
  Widget build(BuildContext context) =>
      _TakeoverAdapter(child: NetworkTakeoverTileView(kind));
}

void _setVpn(WidgetRef ref, bool value) => ref
    .read(vpnSettingProvider.notifier)
    .update((state) => state.copyWith(enable: value));

/// The VPN switch in the grid's control row, in place of the takeover tiles.
class VpnTile extends ConsumerWidget {
  const VpnTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final metrics = takeoverTileMetricsOf(DashboardDensityScope.of(context));
    final enabled = ref.watch(
      vpnSettingProvider.select((state) => state.enable),
    );
    return DashboardCard(
      padding: EdgeInsets.zero,
      child: DashboardSwitchRow(
        glyph: AppGlyphs.vpn,
        title: 'VPN',
        subtitle: metrics.subtitle
            ? enabled
                  ? appLocalizations.enabled
                  : appLocalizations.disabled
            : null,
        value: enabled,
        iconSize: metrics.icon,
        padding: metrics.padding,
        radius: metrics.radius,
        color: Colors.transparent,
        onTap: () => _setVpn(ref, !enabled),
        onChanged: (value) => _setVpn(ref, value),
      ),
    );
  }
}

class VpnCard extends ConsumerWidget {
  const VpnCard({super.key});

  static const _iconSize = 48.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final colorScheme = context.colorScheme;
    final colors = DashboardColors.of(context);
    final enabled = ref.watch(
      vpnSettingProvider.select((state) => state.enable),
    );
    void change(bool value) => _setVpn(ref, value);
    return DashboardCard(
      semanticLabel: 'VPN',
      padding: dashboardCardPadding(
        DashboardDensityScope.of(context),
      ).copyWith(top: 16, bottom: 16),
      onTap: () => change(!enabled),
      child: Row(
        spacing: 14,
        children: [
          ShapeBadge(
            shape: enabled
                ? MaterialShapes.cookie6Sided
                : MaterialShapes.circle,
            color: enabled ? colorScheme.primary : colors.tone,
            size: _iconSize,
            child: GlyphIcon(
              AppGlyphs.vpn,
              size: 22,
              color: enabled
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'VPN',
                  style: AppTextStyle.callout.of(context, emphasized: true),
                ),
                Text(
                  enabled
                      ? appLocalizations.enabled
                      : appLocalizations.disabled,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.footnote
                      .of(context)
                      .copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          DashboardSwitch(
            value: enabled,
            semanticLabel: 'VPN',
            onChanged: change,
          ),
        ],
      ),
    );
  }
}
