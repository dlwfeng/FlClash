/// The outbound the app adds to the running config while Tailscale is on.
/// It is also the name the Core answers `tailscaleStatus` for.
const tailscaleProxyName = 'Tailscale';

const _tailscaleIPv4CIDR = '100.64.0.0/10';
const _tailscaleIPv6CIDR = 'fd7a:115c:a1e0::/48';
const _tailscaleDomainSuffix = 'ts.net';

String tailscaleHostname(String hostname) {
  final trimmed = hostname.trim();
  return trimmed.isEmpty ? 'flclash' : trimmed;
}

/// The outbound the control connection dials through: the configured one, or
/// the profile's own default outbound, so the tunnel never dials itself.
String tailscaleDialerProxy({
  required String configured,
  required String? defaultTarget,
  String proxyName = tailscaleProxyName,
}) {
  final target = configured.trim().isNotEmpty
      ? configured.trim()
      : defaultTarget?.trim() ?? '';
  return target == proxyName ? '' : target;
}

List<String> tailscaleRuleValues({String proxyName = tailscaleProxyName}) => [
  'IP-CIDR,$_tailscaleIPv4CIDR,$proxyName,no-resolve',
  'IP-CIDR6,$_tailscaleIPv6CIDR,$proxyName,no-resolve',
  'DOMAIN-SUFFIX,$_tailscaleDomainSuffix,$proxyName',
];

/// The outbound the Core parses beside the profile's own. [stateDir] keeps the
/// device identity and its login across applies and restarts.
Map<String, dynamic> tailscaleProxyDefinition({
  required String hostname,
  required String stateDir,
  required String dialerProxy,
}) => {
  'name': tailscaleProxyName,
  'type': 'tailscale',
  'hostname': tailscaleHostname(hostname),
  'state-dir': stateDir,
  if (dialerProxy.isNotEmpty) 'dialer-proxy': dialerProxy,
};

/// The Tailnet domain suffix resolves through the node itself, so a profile
/// that resolves names in redir-host mode still reaches MagicDNS names.
/// A profile without its own DNS section is left alone.
Map<String, dynamic> tailscaleDns(
  Object? dns, {
  String proxyName = tailscaleProxyName,
}) {
  if (dns is! Map) {
    return const {};
  }
  final next = Map<String, dynamic>.from(dns);
  if (next['enable'] != true) {
    return next;
  }
  final policy = next['nameserver-policy'];
  return {
    ...next,
    'nameserver-policy': {
      if (policy is Map) ...Map<String, dynamic>.from(policy),
      '+.$_tailscaleDomainSuffix': 'tailscale://$proxyName',
    },
  };
}
