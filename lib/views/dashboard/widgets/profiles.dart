import 'dart:math' as math;

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/dashboard/layout.dart';
import 'package:fl_clash/views/dashboard/style.dart';
import 'package:fl_clash/views/profiles/custom/custom.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'card.dart';
import 'profile_detail.dart';
import 'profiles_view.dart';

ProfileUsage? _usageOf(Profile? profile) {
  final info = profile?.subscriptionInfo;
  if (info == null || info.total <= 0) {
    return null;
  }
  final used = info.upload + info.download;
  return (
    used: used,
    total: info.total,
    share: (used / info.total).clamp(0.0, 1.0).toDouble(),
  );
}

DateTime? _expiryOf(Profile? profile) {
  final expire = profile?.subscriptionInfo?.expire ?? 0;
  return expire > 0 ? DateTime.fromMillisecondsSinceEpoch(expire * 1000) : null;
}

int _daysLeft(DateTime expiry) =>
    math.max(0, expiry.difference(DateTime.now()).inDays);

String _expiryText(BuildContext context, DateTime expiry) =>
    context.appLocalizations.profileExpiresIn(expiry.show, _daysLeft(expiry));

void _openProfile(BuildContext context, Profile? profile) {
  switch (profile) {
    case null:
      showProfilesSheet(context);
    case Profile(type: ProfileType.custom, :final id):
      showCustomProfileSheet(context, id);
    case _:
      showProfileDetailSheet(context);
  }
}

String _sourceOf(BuildContext context, ProfileType type) => switch (type) {
  ProfileType.url => context.appLocalizations.remote,
  ProfileType.file => context.appLocalizations.local,
  ProfileType.custom => context.appLocalizations.custom,
};

class ProfilesCard extends ConsumerWidget {
  const ProfilesCard({super.key});

  static const _soonDays = 7;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final density = DashboardDensityScope.of(context);
    final mobile = !density.isDesktop;
    final compact = density.isCompact;
    final appLocalizations = context.appLocalizations;
    final profile = ref.watch(currentProfileProvider);
    final switchable = ref.watch(
      profilesProvider.select((profiles) => profiles.length > 1),
    );
    final usage = _usageOf(profile);
    final expiry = _expiryOf(profile);
    final updatedAt = profile?.lastUpdateDate;
    final label = DashboardText.label(context);
    final figure = mobile
        ? AppTextStyle.title3
        : (compact ? AppTextStyle.callout : AppTextStyle.headline);
    final endText = switch ((profile, expiry)) {
      (_, final expiry?) => appLocalizations.profileDaysLeft(_daysLeft(expiry)),
      (final profile?, null) => _sourceOf(context, profile.type),
      _ => null,
    };
    final Widget? end = switch ((endText, expiry)) {
      (final text?, final expiry?) => Tooltip(
        message: _expiryText(context, expiry),
        child: Text(
          text,
          maxLines: 1,
          style: _daysLeft(expiry) <= _soonDays
              ? label.copyWith(color: DashboardColors.of(context).warn)
              : label,
        ),
      ),
      (final text?, null) => Text(text, maxLines: 1, style: label),
      _ => null,
    };
    final sync = profile != null && profile.type == ProfileType.url
        ? _SyncButton(profile: profile)
        : null;
    return ProfilesCardView(
      profileLabel: profile?.realLabel,
      hasProfile: profile != null,
      switchable: switchable,
      updatedText: updatedAt?.getLastUpdateTimeDesc(context),
      endText: endText,
      end: end,
      sync: sync,
      footer: usage != null
          ? ProfileUsageMeterView(
              usage: usage,
              figure: figure,
              gap: mobile ? 8 : 6,
            )
          : _ConfigStats(figure: figure),
      onOpen: () => _openProfile(context, profile),
      onSwitch: () => showProfilesSheet(context),
    );
  }
}

class _SyncButton extends ConsumerWidget {
  const _SyncButton({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUpdating = ref.watch(isUpdatingProvider(profile.updatingKey));
    if (isUpdating) {
      return const SizedBox.square(
        dimension: 32,
        child: Center(child: CommonCircleLoading(size: 18)),
      );
    }
    return DashboardIconButton(
      glyph: AppGlyphs.sync,
      tooltip: context.appLocalizations.update,
      onPressed: () => syncProfile(ref, profile),
    );
  }
}

class _ConfigStats extends ConsumerStatefulWidget {
  const _ConfigStats({required this.figure});

  final AppTextStyle figure;

  @override
  ConsumerState<_ConfigStats> createState() => _ConfigStatsState();
}

class _ConfigStatsState extends ConsumerState<_ConfigStats>
    with ConfigCountsWatch<_ConfigStats> {
  @override
  Widget build(BuildContext context) {
    watchConfigCounts();
    final providers = ref.watch(providersProvider);
    final stats = switch (configCounts) {
      final counts? => profileStatsOf(counts, providers),
      null => null,
    };
    return ProfileConfigStatsView(
      stats: stats,
      failed: configCountsFailed,
      figureStyle: widget.figure,
    );
  }
}
