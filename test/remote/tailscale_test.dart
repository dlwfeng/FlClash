import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/remote/client.dart';
import 'package:fl_clash/remote/tailscale.dart';
import 'package:fl_clash/ui/switch.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/test_app.dart';

class _Client extends RemoteControlClient {
  _Client({
    required Map<String, dynamic> tailscale,
    this.status = const {'state': 'Running'},
    this.running = true,
  }) {
    state = {
      'ready': true,
      'running': running,
      'config': {
        'appSettingProps': {'tailscale': tailscale},
      },
      'groups': [
        {'name': 'Proxy', 'type': 'Selector'},
      ],
    };
  }

  final Map<String, dynamic>? status;
  final bool running;
  final commands = <Map<String, Object?>>[];
  final patches = <({String section, Object? value, Object? expected})>[];

  @override
  Future<Object?> command(
    String command, [
    Map<String, Object?> args = const {},
  ]) async {
    commands.add({'command': command, ...args});
    return command == 'tailscaleStatus' ? status : null;
  }

  @override
  Future<Object?> patchSettings(
    String section,
    Object? value,
    Object? expected,
  ) async {
    patches.add((section: section, value: value, expected: expected));
    state = {
      ...state!,
      'config': {...(state!['config'] as Map), section: value},
    };
    notifyListeners();
    return null;
  }
}

void main() {
  Future<void> pumpPage(WidgetTester tester, _Client client) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      TestApp(
        wrapInProviderScope: true,
        child: RemoteTailscalePage(client: client),
        homeBuilder: (child) => Scaffold(body: child),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('the Web page reads the state and the node from the Core', (
    tester,
  ) async {
    final client = _Client(tailscale: {'enabled': true, 'hostname': 'phone'});

    await pumpPage(tester, client);

    expect(
      find.text(currentAppLocalizations.tailscaleStateRunning),
      findsOneWidget,
    );
    expect(
      client.commands.map((command) => command['command']),
      contains('tailscaleStatus'),
    );
    expect(
      client.commands.last,
      allOf(
        containsPair('command', 'tailscaleStatus'),
        containsPair('name', 'Tailscale'),
      ),
    );
  });

  testWidgets('a node that needs login offers the authorization link', (
    tester,
  ) async {
    final client = _Client(
      tailscale: {'enabled': true},
      status: {
        'state': 'NeedsLogin',
        'authUrl': 'https://login.tailscale.com/a/example',
      },
    );

    await pumpPage(tester, client);

    expect(
      find.text(currentAppLocalizations.tailscaleStateNeedsLogin),
      findsOneWidget,
    );
    expect(find.text(currentAppLocalizations.tailscaleLogin), findsOneWidget);
  });

  testWidgets('a settings change is saved before the profile applies', (
    tester,
  ) async {
    final client = _Client(tailscale: {'enabled': false});

    await pumpPage(tester, client);
    expect(find.text(currentAppLocalizations.status), findsNothing);

    await tester.tap(find.byType(CommonSwitch));
    await tester.pumpAndSettle();

    expect(client.patches, hasLength(1));
    final saved = client.patches.single;
    expect(saved.section, 'appSettingProps');
    expect((saved.value as Map)['tailscale'], containsPair('enabled', true));
    expect(client.commands.map((command) => command['command']), [
      'apply',
      'tailscaleStatus',
    ]);
  });

  testWidgets('a stopped Core reports no state and asks it nothing', (
    tester,
  ) async {
    final client = _Client(tailscale: {'enabled': true}, running: false);

    await pumpPage(tester, client);

    expect(find.text(currentAppLocalizations.unknown), findsOneWidget);
    expect(
      client.commands.where(
        (command) => command['command'] == 'tailscaleStatus',
      ),
      isEmpty,
    );
  });
}
