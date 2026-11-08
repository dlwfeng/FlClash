import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/desktop/model.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/core/method.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/config/tailscale.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

class _FakeCoreHandler extends CoreHandlerInterface {
  _FakeCoreHandler(this.status);

  final Map<String, dynamic> status;

  @override
  Future<CoreLifecycleResult> start() async => const CoreLifecycleResult(
    revision: 1,
    outcome: CoreLifecycleOutcome.applied,
  );

  @override
  Future<CoreLifecycleResult> restart() => start();

  @override
  Future<CoreLifecycleResult> stop() => start();

  @override
  Future<CoreLifecycleResult> close() => start();

  @override
  Future<T?> invokeMethod<T>({
    required CoreMethod method,
    Object? arguments,
    Duration? timeout,
  }) async {
    if (method == CoreMethod.tailscaleStatus) {
      return status as T;
    }
    throw UnimplementedError('${method.name} is not part of this test');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpView(
    WidgetTester tester, {
    required bool enabled,
    Map<String, dynamic> status = const {'state': 'Running'},
  }) async {
    final container = ProviderContainer(
      overrides: [
        appSettingProvider.overrideWithBuild(
          (_, _) => defaultAppSettingProps.copyWith.tailscale(enabled: enabled),
        ),
        isStartProvider.overrideWithValue(true),
        coreHandlerProvider.overrideWithValue(
          CoreController.scoped(_FakeCoreHandler(status)),
        ),
      ],
    );
    addTearDown(container.dispose);
    globalState.container = container;

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(child: TailscalePage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('a disabled module keeps the status out of the page', (
    tester,
  ) async {
    await pumpView(tester, enabled: false);

    expect(find.text(currentAppLocalizations.enabled), findsOneWidget);
    expect(find.text(currentAppLocalizations.status), findsNothing);
  });

  testWidgets('a connected node shows its state and no login row', (
    tester,
  ) async {
    await pumpView(tester, enabled: true);

    expect(
      find.text(currentAppLocalizations.tailscaleStateRunning),
      findsOneWidget,
    );
    expect(find.text(currentAppLocalizations.tailscaleLogin), findsNothing);
  });

  testWidgets('a node that needs login offers the authorization link', (
    tester,
  ) async {
    await pumpView(
      tester,
      enabled: true,
      status: {
        'state': 'NeedsLogin',
        'authUrl': 'https://login.tailscale.com/a/example',
      },
    );

    expect(
      find.text(currentAppLocalizations.tailscaleStateNeedsLogin),
      findsOneWidget,
    );
    expect(find.text(currentAppLocalizations.tailscaleLogin), findsOneWidget);
  });
}
