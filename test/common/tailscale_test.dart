import 'package:fl_clash/common/common.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the Tailscale rules name the node and its ranges', () {
    expect(tailscaleRuleValues(), [
      'IP-CIDR,100.64.0.0/10,Tailscale,no-resolve',
      'IP-CIDR6,fd7a:115c:a1e0::/48,Tailscale,no-resolve',
      'DOMAIN-SUFFIX,ts.net,Tailscale',
    ]);
  });

  test('the definition keeps the identity in a state directory', () {
    expect(
      tailscaleProxyDefinition(
        hostname: ' phone ',
        stateDir: '/tmp/state',
        dialerProxy: 'Proxy',
      ),
      {
        'name': 'Tailscale',
        'type': 'tailscale',
        'hostname': 'phone',
        'state-dir': '/tmp/state',
        'dialer-proxy': 'Proxy',
      },
    );
  });

  test('a blank hostname keeps the default device name', () {
    expect(tailscaleHostname('  '), 'flclash');
    expect(
      tailscaleProxyDefinition(
        hostname: '',
        stateDir: '/tmp/state',
        dialerProxy: '',
      ),
      isNot(contains('dialer-proxy')),
    );
  });

  test('the control connection never dials through the node itself', () {
    expect(
      tailscaleDialerProxy(configured: '', defaultTarget: 'Proxy'),
      'Proxy',
    );
    expect(
      tailscaleDialerProxy(configured: 'Other', defaultTarget: 'Proxy'),
      'Other',
    );
    expect(
      tailscaleDialerProxy(configured: '', defaultTarget: 'Tailscale'),
      '',
    );
    expect(tailscaleDialerProxy(configured: '  ', defaultTarget: null), '');
  });

  test('MagicDNS names resolve through the node, other policy is kept', () {
    expect(
      tailscaleDns({
        'enable': true,
        'nameserver-policy': {'+.example.com': '223.5.5.5'},
      }),
      {
        'enable': true,
        'nameserver-policy': {
          '+.example.com': '223.5.5.5',
          '+.ts.net': 'tailscale://Tailscale',
        },
      },
    );
  });

  test('a profile without a DNS section is left alone', () {
    expect(tailscaleDns(null), const {});
    expect(tailscaleDns({'enable': false, 'nameserver': []}), {
      'enable': false,
      'nameserver': [],
    });
  });
}
