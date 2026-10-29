import 'dart:async';

import 'package:fl_clash/enum/proxies.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/proxies.dart';
import 'package:fl_clash/remote/client.dart';
import 'package:fl_clash/remote/proxies.dart';
import 'package:fl_clash/views/proxies/card.dart';
import 'package:fl_clash/views/proxies/bindings.dart' as shared;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/views/proxies/proxies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/test_app.dart';

class _Client extends RemoteControlClient {
  _Client() {
    state = {
      'ready': true,
      'config': {
        'currentProfileId': '1',
        'proxiesStyleProps': {'type': 'tab'},
        'patchClashConfig': {'mode': 'rule', 'testUrl': 'https://example.com'},
      },
      'profiles': [
        {'id': '1', 'type': 'url', 'currentGroupName': 'Nodes'},
      ],
      'groups': [
        {
          'name': 'Nodes',
          'type': 'select',
          'hidden': false,
          'now': 'Alpha',
          'all': [
            {'name': 'Alpha', 'type': 'ss'},
            {'name': 'Beta', 'type': 'vmess'},
          ],
        },
      ],
      'selectedMap': {'Nodes': 'Alpha'},
      'delays': {
        'https://example.com': {'Alpha': 42},
      },
    };
  }
  final commands = <String>[];
  bool fail = false;
  Completer<void>? gate;

  @override
  Future<Object?> command(
    String command, [
    Map<String, Object?> args = const {},
  ]) async {
    commands.add(command);
    await gate?.future;
    if (fail) throw StateError('fixture failure');
    if (command == 'selectProxy') {
      state!['selectedMap'] = {args['group']: args['proxy']};
      notifyListeners();
    }
    return null;
  }

  @override
  Future<Object?> patchSettings(
    String section,
    Object? value,
    Object? expected,
  ) async {
    (state!['config'] as Map)[section] = value;
    notifyListeners();
    return null;
  }
}

void main() {
  late _Client client;
  late RemoteProxyAdapter adapter;
  late List<String> errors;

  setUp(() async {
    await AppLocalizations.load(const Locale('en'));
    client = _Client();
    errors = [];
    adapter = RemoteProxyAdapter(
      client,
      localizations: () => AppLocalizations.current,
      showError: errors.add,
    );
  });
  tearDown(() {
    adapter.dispose();
    client.dispose();
  });

  test('uses shared group selection, search and resolved delays', () {
    expect(adapter.selectedName('Nodes'), 'Alpha');
    expect(adapter.delay('Nodes', null), 42);
    adapter.search('VMESS beta');
    expect(adapter.groups.single.all.single.name, 'Beta');
    adapter.search('missing');
    expect(adapter.groups, isEmpty);
  });

  test('style changes use shared sorting and filtering', () async {
    adapter.updateStyle(
      (style) => style.copyWith(sortType: ProxiesSortType.name),
    );
    await Future<void>.delayed(Duration.zero);
    expect(adapter.style.sortType, ProxiesSortType.name);
    expect(adapter.groups.single.all.map((proxy) => proxy.name), [
      'Alpha',
      'Beta',
    ]);
  });

  test('unsupported actions retain explicit localized feedback', () async {
    await adapter.delayTestPageGroup('Nodes');
    adapter.addToLocalProxies('Alpha');
    expect(errors, hasLength(2));
    expect(
      errors.every((error) => error.contains('not available on Web')),
      isTrue,
    );
    expect(client.commands, isEmpty);
  });

  testWidgets(
    'selection updates immediately and rolls back after a failed request',
    (tester) async {
      client.fail = true;
      adapter.changeProxyDebounce('Nodes', 'Beta');
      expect(adapter.selectedName('Nodes'), 'Beta');
      await tester.pump(const Duration(milliseconds: 600));
      expect(adapter.selectedName('Nodes'), 'Alpha');
      expect(errors.single, 'fixture failure');
    },
  );

  testWidgets('failed delay requests clear pending presentation', (
    tester,
  ) async {
    client.fail = true;
    client.gate = Completer<void>();
    final operation = adapter.proxyDelayTest(
      const Proxy(name: 'Alpha', type: 'ss'),
      null,
    );
    expect(adapter.phase('Alpha', null), DelayTestPhase.running);
    client.gate!.complete();
    await tester.pump();
    await operation;
    expect(adapter.phase('Alpha', null), isNull);
    expect(errors.single, 'fixture failure');
  });

  testWidgets(
    'remote adapter renders the original desktop page and node cards',
    (tester) async {
      await tester.pumpWidget(
        TestApp(
          wrapInProviderScope: true,
          child: RemoteProxiesPage(client: client),
          homeBuilder: (child) => Scaffold(body: child),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ProxiesView), findsOneWidget);
      expect(find.byType(ProxyCard), findsNWidgets(2));
      expect(find.text('Beta'), findsOneWidget);
      await tester.tap(find.text('Beta'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      expect(client.commands, contains('selectProxy'));
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets('polling preserves the mounted search and expansion state', (
    tester,
  ) async {
    await tester.pumpWidget(
      TestApp(
        wrapInProviderScope: true,
        child: ListenableBuilder(
          listenable: client,
          builder: (_, _) => RemoteProxiesPage(client: client),
        ),
        homeBuilder: (child) => Scaffold(body: child),
      ),
    );
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(ProxiesView)),
    );
    final mountedAdapter = container.read(shared.proxyPageAdapterProvider)!;
    await tester.tap(find.byTooltip(AppLocalizations.current.search));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Beta');
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'Beta',
    );
    mountedAdapter.updateCurrentUnfoldSet({'Nodes'});
    await tester.pumpAndSettle();
    client.notifyListeners();
    await tester.pumpAndSettle();
    expect(
      container.read(shared.proxyPageAdapterProvider),
      same(mountedAdapter),
    );
    expect(mountedAdapter.query, 'Beta');
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'Beta',
    );
    expect(mountedAdapter.unfoldSet, {'Nodes'});
    expect(find.byType(ProxyCard), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
