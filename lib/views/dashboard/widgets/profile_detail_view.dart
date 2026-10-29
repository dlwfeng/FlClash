import 'package:fl_clash/l10n/context.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:material_ui/material_ui.dart';
import 'profiles_view.dart';

const _statSpacing = 8.0;

class ProfileDetailSheetView extends StatelessWidget {
  const ProfileDetailSheetView({
    super.key,
    required this.title,
    required this.isRemote,
    required this.isUpdating,
    required this.onSync,
    required this.onPreview,
    required this.stats,
    required this.failed,
    required this.subscription,
    required this.lastUpdate,
    required this.extendLabel,
    required this.providers,
  });
  final String title;
  final bool isRemote, isUpdating, failed;
  final VoidCallback onSync, onPreview;
  final ProfileStats? stats;
  final Widget? subscription, providers;
  final Widget lastUpdate;
  final String? extendLabel;
  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return CommonScaffold(
      title: title,
      iconActions: [
        if (isRemote)
          IconButtonData(
            glyph: AppGlyphs.sync,
            tooltip: appLocalizations.sync,
            isLoading: isUpdating,
            onPressed: onSync,
          ),
        IconButtonData(
          glyph: AppGlyphs.eye,
          tooltip: appLocalizations.runtimeConfig,
          onPressed: onPreview,
        ),
      ],
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(
              top: context.contentTopPadding,
              bottom: 20 + context.bottomInset,
            ),
            sliver: SliverMainAxisGroup(
              slivers: [
                SliverList.list(
                  children: [
                    ProfileStatsGridView(stats: stats, failed: failed),
                    ?subscription,
                    generateSection(
                      title: appLocalizations.profile,
                      items: [
                        _InfoRow(
                          label: appLocalizations.lastUpdated,
                          value: lastUpdate,
                        ),
                        if (extendLabel != null)
                          _InfoRow(
                            label: appLocalizations.extendMode,
                            value: Text(extendLabel!),
                          ),
                      ],
                    ),
                  ],
                ),
                ?providers,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileStatsGridView extends StatelessWidget {
  const ProfileStatsGridView({
    super.key,
    required this.stats,
    required this.failed,
  });

  final ProfileStats? stats;
  final bool failed;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final stats = this.stats;
    final tiles = [
      (appLocalizations.proxyGroup, stats?.groups),
      (appLocalizations.proxies, stats?.proxies),
      (appLocalizations.rules, stats?.rules),
      (appLocalizations.providers, stats?.providers),
    ];
    Widget rowOf(Iterable<(String, int?)> pair) {
      return Row(
        spacing: _statSpacing,
        children: [
          for (final (label, value) in pair)
            Expanded(
              child: _StatTile(
                label: label,
                value: value?.toString() ?? (failed ? '-' : null),
              ),
            ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        spacing: _statSpacing,
        children: [rowOf(tiles.take(2)), rowOf(tiles.skip(2))],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: ShapeDecoration(
        color: context.raisedSurfaceLevel.colorOf(colorScheme),
        shape: AppShape.all(AppCorner.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 2,
        children: [
          Text(
            value ?? '0',
            maxLines: 1,
            style: AppTextStyle.title2
                .of(context, emphasized: true)
                .copyWith(color: colorScheme.onSurface),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.footnote
                .of(context)
                .copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return ListItem(
      title: Text(label),
      trailing: DefaultTextStyle.merge(
        style: AppTextStyle.subheadline
            .of(context)
            .copyWith(color: context.colorScheme.onSurfaceVariant),
        child: value,
      ),
    );
  }
}
