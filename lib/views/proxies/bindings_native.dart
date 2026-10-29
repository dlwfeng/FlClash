import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/proxies.dart';
import 'package:fl_clash/providers/providers.dart' as native;
import 'package:fl_clash/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bindings.dart';

ProxiesStyleProps style(Ref ref) =>
    ref.watch(native.proxiesStyleSettingProvider);
void updateStyle(
  Ref ref,
  ProxiesStyleProps Function(ProxiesStyleProps) update,
) => ref.read(native.proxiesStyleSettingProvider.notifier).update(update);
String query(Ref ref) => ref.watch(native.queryProvider(QueryTag.proxies));
void search(Ref ref, String value) =>
    ref.read(native.queryProvider(QueryTag.proxies).notifier).value = value;
bool isLoading(Ref ref) =>
    ref.watch(native.loadingProvider(LoadingTag.proxies));
String? profileId(Ref ref) => ref.watch(
  native.currentProfileProvider.select((profile) => profile?.id.toString()),
);
bool isCustomProfile(Ref ref) => ref.watch(
  native.currentProfileProvider.select(
    (profile) => profile?.type == ProfileType.custom,
  ),
);
Set<String> unfoldSet(Ref ref) => ref.watch(native.unfoldSetProvider);
Set<String> testingGroups(Ref ref) =>
    ref.watch(native.delayTestingGroupsProvider);
bool currentGroupTesting(Ref ref) =>
    ref.watch(native.currentGroupDelayTestingProvider);
ProxiesListState listState(Ref ref) =>
    ref.watch(native.proxiesListStateProvider);
ProxiesTabState tabState(Ref ref) => ref.watch(native.proxiesTabStateProvider);
ProxiesTabControllerState tabControllerState(Ref ref) =>
    ref.watch(native.proxiesTabControllerStateProvider);
String? proxyName(Ref ref, String name) =>
    ref.watch(native.proxyNameProvider(name));
String? selectedName(Ref ref, String name) =>
    ref.watch(native.selectedProxyNameProvider(name));
SelectedProxyState realSelected(Ref ref, String name) =>
    ref.watch(native.realSelectedProxyStateProvider(name));
int? delay(Ref ref, String name, String? url) =>
    ref.watch(native.delayProvider(proxyName: name, testUrl: url));
DelayTestPhase? phase(Ref ref, String name, String? url) =>
    ref.watch(native.delayTestPhaseProvider(proxyName: name, testUrl: url));
void selectionWarning() => dialogs.showNotifier(
  currentAppLocalizations.notSelectedTip,
  level: MessageLevel.warning,
);
ProxyPageActions actions(Ref ref) => _NativeActions(ref);

class _NativeActions implements ProxyPageActions {
  _NativeActions(this.ref);
  final Ref ref;
  @override
  void changeProxyDebounce(String group, String proxy) => ref
      .read(native.proxiesActionProvider.notifier)
      .changeProxyDebounce(group, proxy);
  @override
  Future<void> delayTestPageGroup(String name) =>
      ref.read(native.proxiesActionProvider.notifier).delayTestPageGroup(name);
  @override
  Future<void> proxyDelayTest(Proxy proxy, String? url) => ref
      .read(native.proxiesActionProvider.notifier)
      .proxyDelayTest(proxy, url);
  @override
  void updateCurrentGroupName(String name) => ref
      .read(native.proxiesActionProvider.notifier)
      .updateCurrentGroupName(name);
  @override
  void updateCurrentUnfoldSet(Set<String> names) => ref
      .read(native.proxiesActionProvider.notifier)
      .updateCurrentUnfoldSet(names);
  @override
  void addToLocalProxies(String name) {
    final action = ref.read(native.proxiesActionProvider.notifier);
    globalState.safeRun(() => action.addToLocalProxies(name));
  }
}

ViewMode viewMode(Ref ref) => ref.watch(native.viewModeProvider);
