import 'package:fl_clash/common/tailscale.dart';
import 'package:fl_clash/views/config/tailscale_page.dart';
import 'package:flutter/widgets.dart';

import 'client.dart';

/// The Web client's Tailscale page. It mounts the same page the desktop app
/// renders, with the Core behind the authenticated remote API.
class RemoteTailscalePage extends StatefulWidget {
  const RemoteTailscalePage({super.key, required this.client});

  final RemoteControlClient client;

  @override
  State<RemoteTailscalePage> createState() => _RemoteTailscalePageState();
}

class _RemoteTailscalePageState extends State<RemoteTailscalePage> {
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.client,
    builder: (context, _) => TailscaleSettingsView(
      controller: _RemoteTailscaleController(widget.client),
    ),
  );
}

class _RemoteTailscaleController implements TailscaleController {
  _RemoteTailscaleController(this.client);

  final RemoteControlClient client;

  Map<String, dynamic> get _state => client.state ?? const {};

  Map<String, dynamic> get _config => _map(_state['config']);

  Map<String, dynamic> get _props =>
      _map(_map(_config['appSettingProps'])['tailscale']);

  static Map<String, dynamic> _map(Object? value) =>
      value is Map ? Map<String, dynamic>.from(value) : {};

  @override
  bool get enabled => _props['enabled'] == true;

  @override
  String get hostname => _props['hostname']?.toString() ?? '';

  @override
  String get dialerProxy => _props['dialerProxy']?.toString() ?? '';

  @override
  List<String> get outboundNames => [
    for (final group in _state['groups'] as List? ?? const [])
      if (group is Map && group['name'] != null) '${group['name']}',
  ];

  @override
  bool get running => _state['running'] == true;

  @override
  Future<TailscaleStatus?> status() async {
    if (!running) {
      return null;
    }
    final result = await client.command('tailscaleStatus', {
      'name': tailscaleProxyName,
    });
    final status = _map(result);
    final state = status['state'];
    if (state is! String) {
      return null;
    }
    return (state: state, authUrl: status['authUrl'] as String?);
  }

  @override
  Future<void> setEnabled(bool value) => _save(enabled: value);

  @override
  Future<void> setHostname(String value) => _save(hostname: value);

  @override
  Future<void> setDialerProxy(String value) => _save(dialerProxy: value);

  Future<void> _save({
    bool? enabled,
    String? hostname,
    String? dialerProxy,
  }) async {
    final previous = _map(_config['appSettingProps']);
    final next = Map<String, dynamic>.from(previous);
    final tailscale = _map(previous['tailscale']);
    if (enabled != null) {
      tailscale['enabled'] = enabled;
    }
    if (hostname != null) {
      tailscale['hostname'] = hostname;
    }
    if (dialerProxy != null) {
      tailscale['dialerProxy'] = dialerProxy;
    }
    next['tailscale'] = tailscale;
    await client.patchSettings('appSettingProps', next, previous);
    await client.command('apply');
  }
}
