import 'package:fl_clash/ui/view_scope.dart';
import 'package:flutter/widgets.dart';
import 'package:fl_clash/common/proxy_layout.dart';
import 'package:fl_clash/enum/proxies.dart';
import 'package:fl_clash/models/proxies.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'bindings_native.dart'
    if (dart.library.js_interop) 'bindings_stub.dart'
    as platform;

abstract class ProxyPageAdapter extends ChangeNotifier
    implements ProxyPageActions {
  ProxiesStyleProps get style;
  String get query;
  List<Group> get groups;
  List<Group> get allGroups;
  String? get profileId;
  String? get currentGroupName;
  Set<String> get unfoldSet;
  bool get isCustomProfile;
  bool get isLoading;
  Set<String> get testingGroups;
  String? proxyName(String groupName);
  String? selectedName(String groupName);
  SelectedProxyState realSelected(String name);
  int? delay(String name, String? url);
  DelayTestPhase? phase(String name, String? url);
  void updateStyle(ProxiesStyleProps Function(ProxiesStyleProps) update);
  void search(String value);
  void selectionWarning();
}

abstract interface class ProxyPageActions {
  void changeProxyDebounce(String group, String proxy);
  Future<void> delayTestPageGroup(String name);
  Future<void> proxyDelayTest(Proxy proxy, String? url);
  void updateCurrentGroupName(String name);
  void updateCurrentUnfoldSet(Set<String> names);
  void addToLocalProxies(String name);
}

final proxyPageAdapterProvider = ChangeNotifierProvider<ProxyPageAdapter?>(
  (ref) => null,
  dependencies: const [],
);
final proxyPageActionsProvider = Provider<ProxyPageActions>(
  (ref) => ref.watch(proxyPageAdapterProvider) ?? platform.actions(ref),
  dependencies: [proxyPageAdapterProvider],
);

class ProxyPageStyle extends Notifier<ProxiesStyleProps> {
  @override
  ProxiesStyleProps build() =>
      ref.watch(proxyPageAdapterProvider)?.style ?? platform.style(ref);
  void update(ProxiesStyleProps Function(ProxiesStyleProps) update) {
    final adapter = ref.read(proxyPageAdapterProvider);
    if (adapter != null) {
      adapter.updateStyle(update);
    } else {
      platform.updateStyle(ref, update);
    }
  }
}

final proxiesStyleSettingProvider =
    NotifierProvider<ProxyPageStyle, ProxiesStyleProps>(
      ProxyPageStyle.new,
      dependencies: [proxyPageAdapterProvider],
    );

class ProxyPageSearch extends Notifier<String> {
  @override
  String build() =>
      ref.watch(proxyPageAdapterProvider)?.query ?? platform.query(ref);
  set value(String value) {
    final adapter = ref.read(proxyPageAdapterProvider);
    if (adapter != null) {
      adapter.search(value);
    } else {
      platform.search(ref, value);
    }
  }
}

final proxySearchProvider = NotifierProvider<ProxyPageSearch, String>(
  ProxyPageSearch.new,
  dependencies: [proxyPageAdapterProvider],
);
final proxyPageLoadingProvider = Provider(
  (ref) =>
      ref.watch(proxyPageAdapterProvider)?.isLoading ?? platform.isLoading(ref),
  dependencies: [proxyPageAdapterProvider],
);
final proxyProfileIdProvider = Provider((ref) {
  final adapter = ref.watch(proxyPageAdapterProvider);
  return adapter == null ? platform.profileId(ref) : adapter.profileId;
}, dependencies: [proxyPageAdapterProvider]);
final isCustomProxyProfileProvider = Provider(
  (ref) =>
      ref.watch(proxyPageAdapterProvider)?.isCustomProfile ??
      platform.isCustomProfile(ref),
  dependencies: [proxyPageAdapterProvider],
);
final unfoldSetProvider = Provider(
  (ref) =>
      ref.watch(proxyPageAdapterProvider)?.unfoldSet ?? platform.unfoldSet(ref),
  dependencies: [proxyPageAdapterProvider],
);
final delayTestingGroupsProvider = Provider(
  (ref) =>
      ref.watch(proxyPageAdapterProvider)?.testingGroups ??
      platform.testingGroups(ref),
  dependencies: [proxyPageAdapterProvider],
);
final currentGroupDelayTestingProvider = Provider((ref) {
  final adapter = ref.watch(proxyPageAdapterProvider);
  return adapter == null
      ? platform.currentGroupTesting(ref)
      : adapter.testingGroups.contains(adapter.currentGroupName);
}, dependencies: [proxyPageAdapterProvider]);
final proxiesListStateProvider = Provider((ref) {
  final adapter = ref.watch(proxyPageAdapterProvider);
  return adapter == null
      ? platform.listState(ref)
      : ProxiesListState(
          groups: adapter.groups,
          currentUnfoldSet: adapter.unfoldSet,
          proxyCardType: adapter.style.cardType,
        );
}, dependencies: [proxyPageAdapterProvider]);
final proxiesTabStateProvider = Provider((ref) {
  final adapter = ref.watch(proxyPageAdapterProvider);
  return adapter == null
      ? platform.tabState(ref)
      : ProxiesTabState(
          groups: adapter.groups,
          currentGroupName: adapter.currentGroupName,
          proxyCardType: adapter.style.cardType,
        );
}, dependencies: [proxyPageAdapterProvider]);
final proxiesTabControllerStateProvider = Provider((ref) {
  final adapter = ref.watch(proxyPageAdapterProvider);
  return adapter == null
      ? platform.tabControllerState(ref)
      : ProxiesTabControllerState(
          groupNames: adapter.groups.map((group) => group.name).toList(),
          currentGroupName: adapter.currentGroupName,
        );
}, dependencies: [proxyPageAdapterProvider]);
final proxyNameProvider = Provider.family<String?, String>((ref, name) {
  final adapter = ref.watch(proxyPageAdapterProvider);
  return adapter == null
      ? platform.proxyName(ref, name)
      : adapter.proxyName(name);
}, dependencies: [proxyPageAdapterProvider]);
final selectedProxyNameProvider = Provider.family<String?, String>((ref, name) {
  final adapter = ref.watch(proxyPageAdapterProvider);
  return adapter == null
      ? platform.selectedName(ref, name)
      : adapter.selectedName(name);
}, dependencies: [proxyPageAdapterProvider]);
final realSelectedProxyStateProvider =
    Provider.family<SelectedProxyState, String>(
      (ref, name) =>
          ref.watch(proxyPageAdapterProvider)?.realSelected(name) ??
          platform.realSelected(ref, name),
      dependencies: [proxyPageAdapterProvider],
    );
final _delayProvider = Provider.family<int?, (String, String?)>((ref, key) {
  final adapter = ref.watch(proxyPageAdapterProvider);
  return adapter == null
      ? platform.delay(ref, key.$1, key.$2)
      : adapter.delay(key.$1, key.$2);
}, dependencies: [proxyPageAdapterProvider]);
Provider<int?> delayProvider({required String proxyName, String? testUrl}) =>
    _delayProvider((proxyName, testUrl));
final _phaseProvider = Provider.family<DelayTestPhase?, (String, String?)>((
  ref,
  key,
) {
  final adapter = ref.watch(proxyPageAdapterProvider);
  return adapter == null
      ? platform.phase(ref, key.$1, key.$2)
      : adapter.phase(key.$1, key.$2);
}, dependencies: [proxyPageAdapterProvider]);
Provider<DelayTestPhase?> delayTestPhaseProvider({
  required String proxyName,
  String? testUrl,
}) => _phaseProvider((proxyName, testUrl));

void showProxySelectionWarning(WidgetRef ref) {
  final adapter = ref.read(proxyPageAdapterProvider);
  if (adapter != null) {
    adapter.selectionWarning();
  } else {
    platform.selectionWarning();
  }
}

void addProxyToLocal(WidgetRef ref, String name) =>
    ref.read(proxyPageActionsProvider).addToLocalProxies(name);

ViewMode proxyPageViewMode(WidgetRef ref, BuildContext context) =>
    ref.watch(proxyPageAdapterProvider) == null
    ? ref.watch(_nativeViewModeProvider)
    : getViewMode(ViewScope.sizeOf(context).width);

final _nativeViewModeProvider = Provider(platform.viewMode);
