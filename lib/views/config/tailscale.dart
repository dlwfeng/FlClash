import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tailscale_page.dart';

/// The desktop and mobile entry. The page itself is shared with the Web
/// client; this only lends it the native providers.
class TailscalePage extends ConsumerWidget {
  const TailscalePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appSettingProvider.select((state) => state.tailscale));
    ref.watch(groupsProvider);
    return TailscaleSettingsView(controller: _NativeTailscaleController(ref));
  }
}

class _NativeTailscaleController implements TailscaleController {
  _NativeTailscaleController(this.ref);

  final WidgetRef ref;

  TailscaleProps get _props => ref.read(appSettingProvider).tailscale;

  @override
  bool get enabled => _props.enabled;

  @override
  String get hostname => _props.hostname;

  @override
  String get dialerProxy => _props.dialerProxy;

  @override
  List<String> get outboundNames => [
    for (final group in ref.read(groupsProvider)) group.name,
  ];

  @override
  bool get running => ref.read(isStartProvider);

  @override
  Future<TailscaleStatus?> status() async {
    try {
      return await ref
          .read(coreHandlerProvider)
          .tailscaleStatus(tailscaleProxyName);
    } catch (error) {
      commonPrint.log('tailscale status failed: $error');
      return null;
    }
  }

  @override
  Future<void> setEnabled(bool value) async {
    _update((props) => props.copyWith(enabled: value));
    await _apply();
  }

  @override
  Future<void> setHostname(String value) async {
    _update((props) => props.copyWith(hostname: value));
    await _apply();
  }

  @override
  Future<void> setDialerProxy(String value) async {
    _update((props) => props.copyWith(dialerProxy: value));
    await _apply();
  }

  void _update(TailscaleProps Function(TailscaleProps props) update) {
    ref
        .read(appSettingProvider.notifier)
        .update((state) => state.copyWith(tailscale: update(state.tailscale)));
  }

  Future<void> _apply() async {
    if (!running) {
      return;
    }
    try {
      await ref.read(setupActionProvider.notifier).applyProfile(silence: true);
    } catch (_) {}
  }
}
