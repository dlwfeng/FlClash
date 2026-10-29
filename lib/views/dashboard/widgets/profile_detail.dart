import 'package:fl_clash/state.dart';
import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/views/profiles/preview.dart';
import 'package:fl_clash/views/profiles/profiles.dart';
import 'package:fl_clash/views/proxies/providers.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'profiles_view.dart';
import 'profile_detail_view.dart';
import 'package:fl_clash/common/applied_config_counts.dart';
export 'profiles_view.dart' show ProfileStats;

Future<void> syncProfile(WidgetRef ref, Profile profile) async {
  await globalState.loadingRun(() async {
    await ref
        .read(profilesActionProvider.notifier)
        .updateProfile(profile, showLoading: true);
  }, tag: LoadingTag.profiles);
}

void showProfileDetailSheet(BuildContext context) {
  showSheet<void>(context: context, builder: (_) => const ProfileDetailSheet());
}

void showProfilesSheet(BuildContext context) {
  showSheet<void>(
    context: context,
    builder: (_) => const ProfilesView(picker: true),
  );
}

ProfileStats profileStatsOf(
  ConfigCounts counts,
  List<ExternalProvider> providers,
) {
  final providedProxies = providers
      .where((provider) => provider.type == 'Proxy')
      .fold(0, (sum, provider) => sum + provider.count);
  return (
    groups: counts.groups,
    proxies: counts.proxies + providedProxies,
    rules: counts.rules,
    providers: providers.length,
  );
}

mixin ConfigCountsWatch<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  ConfigCounts? configCounts = cachedAppliedConfigCounts();
  bool configCountsFailed = false;
  var _generation = 0;

  @override
  void initState() {
    super.initState();
    if (configCounts == null) {
      unawaited(_reloadCounts());
    }
  }

  Future<void> _reloadCounts() async {
    final generation = ++_generation;
    ConfigCounts? counts;
    var failed = false;
    try {
      counts = await loadAppliedConfigCounts();
    } catch (error) {
      commonPrint.log('read applied config error: $error');
      failed = true;
    }
    if (!mounted || generation != _generation) {
      return;
    }
    setState(() {
      configCounts = counts ?? configCounts;
      configCountsFailed = failed || counts == null;
    });
  }

  /// Called from build: groups refresh after every applied setup.
  void watchConfigCounts() {
    ref.listen(groupsProvider, (_, _) {
      final cached = cachedAppliedConfigCounts();
      if (cached == null) {
        unawaited(_reloadCounts());
      } else if (cached != configCounts) {
        _generation++;
        setState(() {
          configCounts = cached;
          configCountsFailed = false;
        });
      }
    });
  }
}

class ProfileDetailSheet extends ConsumerStatefulWidget {
  const ProfileDetailSheet({super.key});

  @override
  ConsumerState<ProfileDetailSheet> createState() => _ProfileDetailSheetState();
}

class _ProfileDetailSheetState extends ConsumerState<ProfileDetailSheet>
    with ConfigCountsWatch<ProfileDetailSheet> {
  void _handlePreview(Profile profile) {
    unawaited(
      BaseNavigator.push<String>(context, PreviewProfileView(profile: profile)),
    );
  }

  @override
  Widget build(BuildContext context) {
    watchConfigCounts();
    final profile = ref.watch(currentProfileProvider);
    if (profile == null) {
      return const SizedBox.shrink();
    }
    final providers = ref.watch(providersProvider);
    final isUpdating = ref.watch(isUpdatingProvider(profile.updatingKey));
    final subscription = profile.subscriptionInfo;
    return ProfileDetailSheetView(
      title: profile.realLabel,
      isRemote: profile.type == ProfileType.url,
      isUpdating: isUpdating,
      onSync: () => syncProfile(ref, profile),
      onPreview: () => _handlePreview(profile),
      stats: configCounts == null
          ? null
          : profileStatsOf(configCounts!, providers),
      failed: configCountsFailed,
      subscription: subscription != null && subscription.total > 0
          ? generateSection(
              title: context.appLocalizations.subscriptionInfo,
              items: [
                ListItem(
                  title: SubscriptionInfoView(subscriptionInfo: subscription),
                ),
              ],
            )
          : null,
      lastUpdate: LastUpdateTimeText(lastUpdateDate: profile.lastUpdateDate),
      extendLabel: profile.type == ProfileType.custom
          ? null
          : _extendLabel(context, profile.extendType),
      providers: providers.isEmpty
          ? null
          : ExternalProvidersSliver(providers: providers),
    );
  }
}

String _extendLabel(BuildContext context, ExtendType type) {
  return switch (type) {
    ExtendType.standard => context.appLocalizations.standard,
    ExtendType.script => context.appLocalizations.script,
  };
}
