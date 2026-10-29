part of 'dashboard_page.dart';

extension _DashboardProfiles on _RemoteDashboardPageState {
  bool _updating(String key) =>
      (state['updatingKeys'] as List?)?.contains(key) == true;

  String _profileName(Map<String, dynamic> profile) {
    final label = profile['label'] as String? ?? '';
    if (label.trim().isNotEmpty) return label;
    return Uri.tryParse('${profile['url']}')?.host.takeUnlessEmpty ??
        '${profile['id']}';
  }

  SubscriptionInfo? _subscription(Object? value) =>
      value is Map ? SubscriptionInfo.fromJson(_object(value)) : null;

  void _chooseProfile() => showSheet<void>(
    context: context,
    builder: (_) => _DashboardSnapshotBuilder(
      owner: this,
      builder: (context) {
        final profiles = _objects(state['profiles']);
        final l = context.appLocalizations;
        return CommonScaffold(
          title: l.profiles,
          body: NullStatusSwitcher(
            isEmpty: profiles.isEmpty,
            nullStatus: NullStatus(
              label: l.nullTip(l.profiles),
              description: l.nullProfileDesc,
              illustration: NullStatusIllustration.profile,
              action: TonalButton(
                size: TonalButtonSize.bar,
                glyph: AppGlyphs.addCircle,
                label: l.addProfile,
                onPressed: () => _unsupported(l.addProfile),
              ),
            ),
            child: ProfilesGridView(
              itemCount: profiles.length,
              selectedIndex: profiles.indexWhere(
                (profile) => profile['id'] == config['currentProfileId'],
              ),
              spacing: cardSpacingOf(
                context,
                getViewMode(MediaQuery.sizeOf(context).width),
              ),
              revealsSelected: false,
              itemBuilder: (context, index) {
                final profile = profiles[index];
                final info = profile['type'] == 'url'
                    ? _subscription(profile['subscriptionInfo'])
                    : null;
                final updated = DateTime.tryParse(
                  '${profile['lastUpdateDate']}',
                );
                final isUpdating = _updating('profile_${profile['id']}');
                final subtitle = info?.usage != null
                    ? '${_trafficText(info!.upload + info.download)} / ${_trafficText(info.total)}'
                    : switch (profile['type']) {
                        'url' => l.remote,
                        'custom' => l.custom,
                        _ => l.local,
                      };
                return ProfilePickerItemView(
                  key: ValueKey(profile['id']),
                  id: profile['id']!,
                  title: _profileName(profile),
                  subtitle: subtitle,
                  expire: info?.expireDate,
                  isSelected: profile['id'] == config['currentProfileId'],
                  onSelect: () =>
                      _command('selectProfile', {'id': profile['id']}),
                  menuItems: isUpdating ? null : _profileMenu(profile),
                  trailing: AnimatedSwitcher(
                    duration: context.motionDuration(commonDuration),
                    layoutBuilder: (current, previous) => Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [...previous, ?current],
                    ),
                    child: isUpdating
                        ? const CommonCircleLoading(
                            key: ValueKey('updating'),
                            size: 24,
                          )
                        : LastUpdateTimeText(
                            key: const ValueKey('lastUpdate'),
                            lastUpdateDate: updated,
                            style: AppTextStyle.footnote.of(context).toLighter,
                            compact: true,
                          ),
                  ),
                );
              },
            ),
          ),
        );
      },
    ),
  );

  List<CommonPopupMenuItem> _profileMenu(Map<String, dynamic> profile) {
    final l = context.appLocalizations;
    final custom = profile['type'] == 'custom';
    final remote = profile['type'] == 'url';
    return [
      CommonPopupMenuItem(
        glyph: AppGlyphs.edit,
        label: l.edit,
        onPressed: () => _unsupported(l.edit),
      ),
      if (custom) ...[
        CommonPopupMenuItem(
          glyph: AppGlyphs.textShort,
          label: l.rename,
          onPressed: () => _unsupported(l.rename),
        ),
        CommonPopupMenuItem(
          glyph: AppGlyphs.eye,
          label: l.runtimeConfig,
          onPressed: () => _unsupported(l.runtimeConfig),
        ),
      ] else
        CommonPopupMenuItem(
          glyph: AppGlyphs.puzzle,
          label: l.extend,
          onPressed: () => _unsupported(l.extend),
        ),
      if (remote)
        CommonPopupMenuItem(
          glyph: AppGlyphs.sync,
          label: l.sync,
          onPressed: () => _command('updateProfile', {'id': profile['id']}),
        ),
      if (!custom)
        CommonPopupMenuItem(
          glyph: AppGlyphs.moreCircle,
          label: l.more,
          subItems: [
            CommonPopupMenuItem(
              glyph: AppGlyphs.eye,
              label: l.runtimeConfig,
              onPressed: () => _unsupported(l.runtimeConfig),
            ),
            if (remote)
              CommonPopupMenuItem(
                glyph: AppGlyphs.copy,
                label: l.copyLink,
                onPressed: () =>
                    Clipboard.setData(ClipboardData(text: '${profile['url']}')),
              ),
            if (remote)
              CommonPopupMenuItem(
                glyph: AppGlyphs.qrCode,
                label: l.qrcode,
                onPressed: () => _unsupported(l.qrcode),
              ),
            CommonPopupMenuItem(
              glyph: AppGlyphs.export,
              label: l.exportFile,
              onPressed: () => _unsupported(l.exportFile),
            ),
          ],
        ),
      CommonPopupMenuItem(
        danger: true,
        glyph: AppGlyphs.delete,
        label: l.delete,
        onPressed: () async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => CommonDialog(
              title: l.tip,
              destructive: true,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(l.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(l.delete),
                ),
              ],
              child: Text(l.deleteTip(l.profile)),
            ),
          );
          if (confirmed == true && mounted) {
            await _command('deleteProfile', {'id': profile['id']});
          }
        },
      ),
    ];
  }

  void _openProfile() {
    final profile = _objects(state['profiles'])
        .where((profile) => profile['id'] == config['currentProfileId'])
        .firstOrNull;
    if (profile == null) {
      _chooseProfile();
      return;
    }
    if (profile['type'] == 'custom') {
      _unsupported(context.appLocalizations.custom);
      return;
    }
    showSheet<void>(
      context: context,
      builder: (_) => _DashboardSnapshotBuilder(
        owner: this,
        builder: (context) {
          final profile = _objects(state['profiles'])
              .where((profile) => profile['id'] == config['currentProfileId'])
              .firstOrNull;
          if (profile == null) return const SizedBox.shrink();
          final l = context.appLocalizations;
          final counts = _object(_snapshot['stats']);
          final subscription = _subscription(profile['subscriptionInfo']);
          final providers = _objects(_snapshot['providers']);
          return ProfileDetailSheetView(
            title: _profileName(profile),
            isRemote: profile['type'] == 'url',
            isUpdating: _updating('profile_${profile['id']}'),
            onSync: () => _command('updateProfile', {'id': profile['id']}),
            onPreview: () => _unsupported(l.runtimeConfig),
            stats: counts.isEmpty
                ? null
                : (
                    groups: _integer(counts['groups']),
                    proxies: _integer(counts['proxies']),
                    rules: _integer(counts['rules']),
                    providers: _integer(counts['providers']),
                  ),
            failed: _snapshot['statsFailed'] == true,
            subscription: subscription != null && subscription.total > 0
                ? generateSection(
                    title: l.subscriptionInfo,
                    items: [
                      ListItem(
                        title: SubscriptionInfoView(
                          subscriptionInfo: subscription,
                        ),
                      ),
                    ],
                  )
                : null,
            lastUpdate: LastUpdateTimeText(
              lastUpdateDate: DateTime.tryParse('${profile['lastUpdateDate']}'),
            ),
            extendLabel: profile['extendType'] == 'script'
                ? l.script
                : l.standard,
            providers: providers.isEmpty
                ? null
                : ExternalProvidersSliverView(
                    itemCount: providers.length,
                    isUpdating: providers.any(
                      (provider) => _updating('provider_${provider['name']}'),
                    ),
                    onUpdate: () async {
                      for (final provider in providers) {
                        await _command('updateProvider', {
                          'name': provider['name'],
                        });
                      }
                    },
                    itemBuilder: (context, index) {
                      final provider = providers[index];
                      return ContextMenuRegion(
                        menuItems: [
                          CommonPopupMenuItem(
                            glyph: AppGlyphs.eye,
                            label: l.runtimeConfig,
                            onPressed: () => _unsupported(l.runtimeConfig),
                          ),
                          CommonPopupMenuItem(
                            glyph: AppGlyphs.upload,
                            label: l.upload,
                            onPressed: () => _unsupported(l.upload),
                          ),
                          if (provider['vehicle-type'] == 'HTTP')
                            CommonPopupMenuItem(
                              glyph: AppGlyphs.sync,
                              label: l.sync,
                              onPressed: () => _command('updateProvider', {
                                'name': provider['name'],
                              }),
                            ),
                        ],
                        child: ExternalProviderItemView(
                          name: '${provider['name']}',
                          type: '${provider['type']}',
                          count: _integer(provider['count']),
                          updateAt:
                              DateTime.tryParse('${provider['update-at']}') ??
                              DateTime.fromMillisecondsSinceEpoch(0),
                          subscriptionInfo: _subscription(
                            provider['subscription-info'],
                          ),
                          isUpdating: _updating('provider_${provider['name']}'),
                          onPressed: () => _unsupported(l.runtimeConfig),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}

String _trafficText(num bytes) {
  final value = dashboardTrafficValue(bytes);
  return '${value.value}${value.unit}';
}

extension _OptionalProfileHost on String {
  String? get takeUnlessEmpty => isEmpty ? null : this;
}
