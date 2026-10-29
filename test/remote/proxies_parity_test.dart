import 'dart:ui' as ui;

import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart' as native;
import 'package:fl_clash/remote/client.dart';
import 'package:fl_clash/remote/proxies.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/proxies/proxies.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/test_app.dart';
import '../helpers/test_profiles.dart';

void main() {
  for (final type in ProxiesType.values) {
    testWidgets(
      '${type.name} renders identical pixels with native and remote data',
      (tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        const style = ProxiesStyleProps();
        final pageStyle = style.copyWith(type: type);
        final profile = Profile.normal().copyWith(
          currentGroupName: 'Nodes',
          unfoldSet: {'Nodes'},
          selectedMap: {'Nodes': 'Alpha'},
        );
        const group = Group(
          name: 'Nodes',
          type: GroupType.Selector,
          hidden: false,
          testUrl: 'https://example.com',
          all: [
            Proxy(name: 'Alpha', type: 'Shadowsocks'),
            Proxy(name: 'Beta', type: 'VLESS'),
          ],
        );
        final container = ProviderContainer(
          overrides: [
            native.viewModeProvider.overrideWithValue(ViewMode.desktop),
            native.currentProfileIdProvider.overrideWithBuild(
              (_, _) => profile.id,
            ),
            native.profilesProvider.overrideWith(() => TestProfiles([profile])),
            native.groupsProvider.overrideWithBuild((_, _) => [group]),
            native.currentGroupsStateProvider.overrideWithValue(
              const GroupsState(value: [group]),
            ),
            native.proxiesStyleSettingProvider.overrideWithBuild(
              (_, _) => pageStyle,
            ),
            native.delayDataSourceProvider.overrideWithBuild(
              (_, _) => {
                'https://example.com': {'Alpha': 42},
              },
            ),
          ],
        );
        addTearDown(container.dispose);
        globalState.container = container;
        container.read(native.viewSizeProvider.notifier).value = const Size(
          1200,
          800,
        );
        final client = RemoteControlClient();
        addTearDown(client.dispose);
        client.state = {
          'ready': true,
          'config': {
            'currentProfileId': '${profile.id}',
            'proxiesStyleProps': pageStyle.toJson(),
            'patchClashConfig': {'mode': 'rule'},
          },
          'profiles': [
            {
              'id': '${profile.id}',
              'type': 'url',
              'currentGroupName': 'Nodes',
              'unfoldSet': ['Nodes'],
            },
          ],
          'groups': [
            group.toJson()
              ..['all'] = group.all.map((proxy) => proxy.toJson()).toList(),
          ],
          'selectedMap': {'Nodes': 'Alpha'},
          'delays': {
            'https://example.com': {'Alpha': 42},
          },
        };
        const key = ValueKey('proxy-page-render');
        Future<ui.Image> capture(Widget child) async {
          await tester.pumpWidget(
            UncontrolledProviderScope(
              container: container,
              child: TestApp(
                includeNavigatorKey: false,
                child: RepaintBoundary(key: key, child: child),
                homeBuilder: (child) => Scaffold(body: child),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final boundary = tester.renderObject<RenderRepaintBoundary>(
            find.byKey(key),
          );
          return (await tester.runAsync(() => boundary.toImage()))!;
        }

        final reference = await capture(const ProxiesView());
        await tester.pumpWidget(const SizedBox());
        final remote = await capture(RemoteProxiesPage(client: client));
        await tester.runAsync(() async {
          final a = (await reference.toByteData())!.buffer.asUint8List();
          final b = (await remote.toByteData())!.buffer.asUint8List();
          expect(b, orderedEquals(a));
        });
        reference.dispose();
        remote.dispose();
        await tester.pumpWidget(const SizedBox());
      },
    );
  }
}
