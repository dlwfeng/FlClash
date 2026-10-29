import 'package:fl_clash/enum/proxies.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/proxies.freezed.dart';
part 'generated/proxies.g.dart';

const defaultProxiesStyleProps = ProxiesStyleProps();
const delayTimedOutValue = -1;
typedef DelayMap = Map<String, Map<String, int?>>;

@freezed
abstract class Group with _$Group {
  const factory Group({
    @JsonKey(fromJson: GroupType.parse) required GroupType type,
    @Default([]) List<Proxy> all,
    String? now,
    bool? hidden,
    String? testUrl,
    @Default('') String icon,
    required String name,
  }) = _Group;

  factory Group.fromJson(Map<String, Object?> json) => _$GroupFromJson(json);
}

final _groupsByName = Expando<Map<String, Group>>();

extension GroupsExt on List<Group> {
  /// Indexed once per list, so a list must not change after its first lookup.
  Group? getGroup(String groupName) => (_groupsByName[this] ??= {
    for (final group in this) group.name: group,
  })[groupName];
}

extension GroupExt on Group {
  String get realNow => now ?? '';

  String getCurrentSelectedName(String proxyName) {
    if (type.isComputedSelected) {
      return realNow.isNotEmpty ? realNow : proxyName;
    }
    return proxyName.isNotEmpty && _isMember(proxyName) ? proxyName : realNow;
  }

  /// A saved pick outlives a subscription update that renames or drops it.
  bool _isMember(String proxyName) =>
      all.isEmpty || all.any((proxy) => proxy.name == proxyName);
}

@freezed
abstract class Proxy with _$Proxy {
  const factory Proxy({
    required String name,
    required String type,
    String? now,
    @JsonKey(name: 'provider-name') String? providerName,
  }) = _Proxy;

  factory Proxy.fromJson(Map<String, Object?> json) => _$ProxyFromJson(json);
}

extension ProxyExt on Proxy {
  List<String> get searchFields => [name, type];
}

/// Reads the styles named `standard`, `icon` and `none` before they became
/// [ProxiesIconStyle.filled], [ProxiesIconStyle.plain] and
/// [ProxiesIconStyle.hidden].
ProxiesIconStyle proxiesIconStyleSafeFromJson(Object? iconStyle) {
  return switch (iconStyle) {
    'filled' || 'standard' => ProxiesIconStyle.filled,
    'plain' || 'icon' => ProxiesIconStyle.plain,
    'hidden' || 'none' => ProxiesIconStyle.hidden,
    _ => ProxiesIconStyle.filled,
  };
}

ProxyCardType proxyCardTypeSafeFromJson(Object? cardType) {
  return switch (cardType) {
    'loose' || 'expand' => ProxyCardType.loose,
    'standard' || 'shrink' => ProxyCardType.standard,
    'compact' || 'min' => ProxyCardType.compact,
    _ => ProxyCardType.standard,
  };
}

@freezed
abstract class ProxiesStyleProps with _$ProxiesStyleProps {
  const factory ProxiesStyleProps({
    @Default(ProxiesType.list) ProxiesType type,
    @Default(ProxiesSortType.none) ProxiesSortType sortType,
    @Default(ProxiesLayout.standard) ProxiesLayout layout,
    @Default(ProxiesIconStyle.filled)
    @JsonKey(fromJson: proxiesIconStyleSafeFromJson)
    ProxiesIconStyle iconStyle,
    @Default(ProxyCardType.standard)
    @JsonKey(fromJson: proxyCardTypeSafeFromJson)
    ProxyCardType cardType,
    @Default(false) bool hideTimeoutProxies,
  }) = _ProxiesStyleProps;

  factory ProxiesStyleProps.fromJson(Map<String, Object?>? json) => json == null
      ? defaultProxiesStyleProps
      : _$ProxiesStylePropsFromJson(json);
}

@freezed
abstract class DelayState with _$DelayState {
  const factory DelayState({required int delay, required bool group}) =
      _DelayState;
}

extension DelayStateExt on DelayState {
  int get priority {
    if (delay > 0) return 0;
    if (delay == 0) return 1;
    if (delay == delayTimedOutValue) return 2;
    return 3;
  }

  int compareTo(DelayState other) {
    if (priority != other.priority) {
      return priority.compareTo(other.priority);
    }
    if (delay != other.delay) {
      return delay.compareTo(other.delay);
    }
    if (group && !other.group) return -1;
    if (!group && other.group) return 1;
    return 0;
  }
}

@freezed
abstract class SelectedProxyState with _$SelectedProxyState {
  const factory SelectedProxyState({
    required String proxyName,
    @Default(false) bool group,
    String? testUrl,
  }) = _SelectedProxyState;
}

@freezed
abstract class ProxiesListState with _$ProxiesListState {
  const factory ProxiesListState({
    required List<Group> groups,
    required Set<String> currentUnfoldSet,
    required ProxyCardType proxyCardType,
  }) = _ProxiesListState;
}

@freezed
abstract class ProxiesTabState with _$ProxiesTabState {
  const factory ProxiesTabState({
    required List<Group> groups,
    required String? currentGroupName,
    required ProxyCardType proxyCardType,
  }) = _ProxiesTabState;
}

@freezed
abstract class ProxiesTabControllerState with _$ProxiesTabControllerState {
  const factory ProxiesTabControllerState({
    required List<String> groupNames,
    required String? currentGroupName,
  }) = _ProxiesTabControllerState;
}
