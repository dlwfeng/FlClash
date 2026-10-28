import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fl_clash/remote/client.dart';
import 'package:fl_clash/remote/main.dart';
import 'package:fl_clash/ui/switch.dart';
import 'package:fl_clash/ui/scaffold.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

class _Adapter implements HttpClientAdapter {
  final commands = <Object?>[];
  final settings = <Object?>[];
  var failState = false;
  Completer<void>? saveGate;
  final state = <String, Object?>{
    'ready': true,
    'running': false,
    'config': {
      'currentProfileId': '374813178134532096',
      'appSettingProps': {'locale': 'en'},
      'themeProps': {},
      'networkProps': {'systemProxy': false},
      'patchClashConfig': {
        'mode': 'rule',
        'tun': {'enable': false},
      },
    },
    'profiles': [
      {
        'id': '374813178134532096',
        'label': 'Remote subscription',
        'type': 'url',
        'url': 'https://example.com/profile',
      },
    ],
    'groups': [],
  };

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    Object? result;
    if (options.path.endsWith('/api/command')) {
      commands.add(options.data);
      if ((options.data as Map)['command'] == 'readProfile') {
        result = 'mixed-port: 7890\nmode: rule\n';
      }
      if ((options.data as Map)['command'] == 'saveProfile') {
        await saveGate?.future;
      }
      if ((options.data as Map)['command'] == 'running') {
        state['running'] = true;
      }
    }
    if (options.path.endsWith('/api/settings')) {
      settings.add(options.data);
      final body = options.data as Map;
      (state['config'] as Map)[body['section']] = body['value'];
    }
    final failed = failState && options.path.endsWith('/api/state');
    return ResponseBody.fromString(
      jsonEncode(
        failed
            ? {'error': 'offline'}
            : {'data': options.path.endsWith('/api/state') ? state : result},
      ),
      failed ? 503 : 200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  Future<(RemoteControlClient, _Adapter)> mount(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final adapter = _Adapter();
    final dio = Dio()..httpClientAdapter = adapter;
    final client = RemoteControlClient(
      http: dio,
      endpoint: 'http://127.0.0.1:9091',
    )..secret = 'test';
    await tester.pumpWidget(RemoteApplication(client: client));
    await tester.pumpAndSettle();
    return (client, adapter);
  }

  testWidgets(
    'running control sends an application command and refreshes state',
    (tester) async {
      final (_, adapter) = await mount(tester);
      expect(find.text('Dashboard'), findsWidgets);
      await tester.tap(find.widgetWithText(FilledButton, 'Start').first);
      await tester.pumpAndSettle();
      expect(adapter.commands, [
        {'command': 'running', 'value': true},
      ]);
      expect(find.widgetWithText(FilledButton, 'Stop'), findsWidgets);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('profile IDs survive sidebar navigation and selection', (
    tester,
  ) async {
    final (_, adapter) = await mount(tester);
    await tester.tap(find.text('Profiles'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remote subscription'));
    await tester.pumpAndSettle();
    expect(adapter.commands, [
      {'command': 'selectProfile', 'id': '374813178134532096'},
    ]);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('a lost connection retains state and disables host mutations', (
    tester,
  ) async {
    final (client, adapter) = await mount(tester);
    adapter.failState = true;
    await tester.runAsync(client.refresh);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Start').first,
          )
          .onPressed,
      isNull,
    );
    expect(find.byType(MaterialBanner), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('shared settings forms persist a switch', (tester) async {
    final (_, adapter) = await mount(tester);
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Network'));
    await tester.pumpAndSettle();
    expect(find.text('System proxy'), findsWidgets);
    await tester.tap(find.byType(CommonSwitch).first);
    await tester.pumpAndSettle();
    expect(adapter.settings, [
      {
        'section': 'networkProps',
        'expected': {'systemProxy': false},
        'value': {'systemProxy': true},
      },
    ]);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('canceling a changed profile asks before discarding', (
    tester,
  ) async {
    await mount(tester);
    await tester.tap(find.text('Profiles'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit').first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'mixed-port: 7891');
    await tester.pump();
    await tester.tap(find.text('Cancel').first);
    await tester.pumpAndSettle();
    expect(find.text('Discard the changes?'), findsOneWidget);
    await tester.tap(find.text('Cancel').last);
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CommonScaffold && widget.title == 'Remote subscription',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Cancel').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm').last);
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CommonScaffold && widget.title == 'Remote subscription',
      ),
      findsNothing,
    );
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('a pending profile save prevents dismissing the form', (
    tester,
  ) async {
    final (_, adapter) = await mount(tester);
    await tester.tap(find.text('Profiles'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit').first);
    await tester.pumpAndSettle();
    adapter.saveGate = Completer<void>();
    await tester.tap(find.text('Save').first);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('Cancel').first);
    await tester.pump(const Duration(milliseconds: 50));
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CommonScaffold && widget.title == 'Remote subscription',
      ),
      findsOneWidget,
    );
    adapter.saveGate!.complete();
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CommonScaffold && widget.title == 'Remote subscription',
      ),
      findsNothing,
    );
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
