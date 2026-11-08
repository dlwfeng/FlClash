import 'dart:async';

import 'package:fl_clash/common/input_limits.dart';
import 'package:fl_clash/l10n/context.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/widgets/feedback.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

typedef TailscaleStatus = ({String state, String? authUrl});

/// What one platform lends the page: the saved settings, the outbounds the
/// dialer picker lists, and the Core call behind the state row.
abstract class TailscaleController {
  bool get enabled;
  String get hostname;
  String get dialerProxy;
  List<String> get outboundNames;
  bool get running;

  Future<TailscaleStatus?> status();

  /// Saves the value and applies it to the running profile.
  Future<void> setEnabled(bool value);
  Future<void> setHostname(String value);
  Future<void> setDialerProxy(String value);
}

String _stateLabel(String state, AppLocalizations l) => switch (state) {
  'NoState' => l.tailscaleStateNoState,
  'NeedsLogin' => l.tailscaleStateNeedsLogin,
  'NeedsMachineAuth' => l.tailscaleStateNeedsMachineAuth,
  'Starting' => l.tailscaleStateStarting,
  'Running' => l.tailscaleStateRunning,
  'Stopped' => l.tailscaleStateStopped,
  _ => state,
};

/// The one Tailscale page the desktop and the Web client mount, so the rows,
/// the states and the login link stay the same whichever Core they reach.
class TailscaleSettingsView extends StatefulWidget {
  const TailscaleSettingsView({super.key, required this.controller});

  final TailscaleController controller;

  @override
  State<TailscaleSettingsView> createState() => _TailscaleSettingsViewState();
}

class _TailscaleSettingsViewState extends State<TailscaleSettingsView>
    with WidgetsBindingObserver {
  TailscaleStatus? _status;
  bool _loading = false;
  int _request = 0;

  TailscaleController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (_controller.enabled) {
      _loading = true;
      unawaited(_load());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// The browser holds the login, so the state is read again on the way back.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed ||
        _loading ||
        !_controller.enabled) {
      return;
    }
    unawaited(_load());
  }

  Future<void> _load() async {
    final request = ++_request;
    if (!_loading) {
      setState(() => _loading = true);
    }
    TailscaleStatus? status;
    try {
      status = await _controller.status();
    } catch (_) {}
    if (!mounted || request != _request) {
      return;
    }
    setState(() {
      _status = status;
      _loading = false;
    });
  }

  Future<void> _handleEnabled(bool enabled) async {
    _request++;
    setState(() {
      _status = null;
      _loading = enabled;
    });
    await _controller.setEnabled(enabled);
    if (!mounted || !enabled) {
      return;
    }
    await _load();
  }

  Future<void> _handleHostname(String value) async {
    await _controller.setHostname(value.trim());
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _handleDialerProxy(String value) async {
    await _controller.setDialerProxy(value);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openAuth(String url) async {
    var opened = false;
    try {
      opened = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {}
    if (!opened && mounted) {
      showAppFeedback(
        context,
        context.appLocalizations.openLinkFailed,
        level: MessageLevel.error,
      );
    }
  }

  List<Widget> _buildStatusItems(AppLocalizations appLocalizations) {
    final status = _status;
    final authUrl = status?.authUrl;
    return [
      ListItem(
        leading: const GlyphIcon(AppGlyphs.status),
        title: Text(
          _loading
              ? appLocalizations.loading
              : status == null
              ? appLocalizations.unknown
              : _stateLabel(status.state, appLocalizations),
        ),
        subtitle: _loading || status != null
            ? null
            : Text(appLocalizations.tailscaleStatusHint),
        trailing: _loading
            ? const CommonCircleLoading(size: 16)
            : const GlyphIcon(AppGlyphs.refresh),
        onTap: _loading ? null : () => unawaited(_load()),
      ),
      if (!_loading && authUrl != null)
        ListItem(
          leading: const GlyphIcon(AppGlyphs.openExternal),
          title: Text(appLocalizations.tailscaleLogin),
          subtitle: Text(appLocalizations.tailscaleLoginDesc),
          trailing: const GlyphIcon(AppGlyphs.chevronForward),
          onTap: () => unawaited(_openAuth(authUrl)),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final enabled = _controller.enabled;
    final outboundNames = _controller.outboundNames;
    final dialerProxy = _controller.dialerProxy;
    return BaseScaffold(
      title: appLocalizations.tailscale,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(
          top: context.sectionsTopPadding,
          bottom: 16 + context.bottomInset,
        ),
        children: [
          generateSection(
            title: appLocalizations.tailscale,
            items: [
              ListItem.toggle(
                leading: const GlyphIcon(AppGlyphs.vpn),
                title: Text(appLocalizations.enabled),
                value: enabled,
                onChanged: (value) => unawaited(_handleEnabled(value)),
              ),
              ListItem.input(
                leading: const GlyphIcon(AppGlyphs.devices),
                title: Text(appLocalizations.hostname),
                dialogTitle: appLocalizations.hostname,
                value: _controller.hostname,
                maxLength: TextInputLimits.domain,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  unawaited(_handleHostname(value));
                },
              ),
              ListItem<String>.options(
                leading: const GlyphIcon(AppGlyphs.swap),
                title: Text(appLocalizations.dialerProxy),
                subtitle: Text(appLocalizations.tailscaleDialerProxyDesc),
                options: [
                  '',
                  ...outboundNames,
                  if (dialerProxy.isNotEmpty &&
                      !outboundNames.contains(dialerProxy))
                    dialerProxy,
                ],
                value: dialerProxy,
                textBuilder: (value) =>
                    value.isEmpty ? appLocalizations.auto : value,
                onChanged: (value) => unawaited(_handleDialerProxy(value)),
              ),
            ],
            footer: appLocalizations.tailscaleEnableDesc,
          ),
          if (enabled)
            generateSection(
              title: appLocalizations.status,
              items: _buildStatusItems(appLocalizations),
            ),
        ],
      ),
    );
  }
}
