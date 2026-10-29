// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../proxies.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Group _$GroupFromJson(Map<String, dynamic> json) => _Group(
  type: GroupType.parse(json['type'] as String),
  all:
      (json['all'] as List<dynamic>?)
          ?.map((e) => Proxy.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  now: json['now'] as String?,
  hidden: json['hidden'] as bool?,
  testUrl: json['testUrl'] as String?,
  icon: json['icon'] as String? ?? '',
  name: json['name'] as String,
);

Map<String, dynamic> _$GroupToJson(_Group instance) => <String, dynamic>{
  'type': _$GroupTypeEnumMap[instance.type]!,
  'all': instance.all,
  'now': instance.now,
  'hidden': instance.hidden,
  'testUrl': instance.testUrl,
  'icon': instance.icon,
  'name': instance.name,
};

const _$GroupTypeEnumMap = {
  GroupType.Selector: 'select',
  GroupType.URLTest: 'url-test',
  GroupType.Fallback: 'fallback',
  GroupType.LoadBalance: 'load-balance',
  GroupType.Relay: 'relay',
};

_Proxy _$ProxyFromJson(Map<String, dynamic> json) => _Proxy(
  name: json['name'] as String,
  type: json['type'] as String,
  now: json['now'] as String?,
  providerName: json['provider-name'] as String?,
);

Map<String, dynamic> _$ProxyToJson(_Proxy instance) => <String, dynamic>{
  'name': instance.name,
  'type': instance.type,
  'now': instance.now,
  'provider-name': instance.providerName,
};

_ProxiesStyleProps _$ProxiesStylePropsFromJson(Map<String, dynamic> json) =>
    _ProxiesStyleProps(
      type:
          $enumDecodeNullable(_$ProxiesTypeEnumMap, json['type']) ??
          ProxiesType.list,
      sortType:
          $enumDecodeNullable(_$ProxiesSortTypeEnumMap, json['sortType']) ??
          ProxiesSortType.none,
      layout:
          $enumDecodeNullable(_$ProxiesLayoutEnumMap, json['layout']) ??
          ProxiesLayout.standard,
      iconStyle: json['iconStyle'] == null
          ? ProxiesIconStyle.filled
          : proxiesIconStyleSafeFromJson(json['iconStyle']),
      cardType: json['cardType'] == null
          ? ProxyCardType.standard
          : proxyCardTypeSafeFromJson(json['cardType']),
      hideTimeoutProxies: json['hideTimeoutProxies'] as bool? ?? false,
    );

Map<String, dynamic> _$ProxiesStylePropsToJson(_ProxiesStyleProps instance) =>
    <String, dynamic>{
      'type': _$ProxiesTypeEnumMap[instance.type]!,
      'sortType': _$ProxiesSortTypeEnumMap[instance.sortType]!,
      'layout': _$ProxiesLayoutEnumMap[instance.layout]!,
      'iconStyle': _$ProxiesIconStyleEnumMap[instance.iconStyle]!,
      'cardType': _$ProxyCardTypeEnumMap[instance.cardType]!,
      'hideTimeoutProxies': instance.hideTimeoutProxies,
    };

const _$ProxiesTypeEnumMap = {ProxiesType.tab: 'tab', ProxiesType.list: 'list'};

const _$ProxiesSortTypeEnumMap = {
  ProxiesSortType.none: 'none',
  ProxiesSortType.delay: 'delay',
  ProxiesSortType.name: 'name',
};

const _$ProxiesLayoutEnumMap = {
  ProxiesLayout.loose: 'loose',
  ProxiesLayout.standard: 'standard',
  ProxiesLayout.tight: 'tight',
};

const _$ProxiesIconStyleEnumMap = {
  ProxiesIconStyle.filled: 'filled',
  ProxiesIconStyle.plain: 'plain',
  ProxiesIconStyle.hidden: 'hidden',
};

const _$ProxyCardTypeEnumMap = {
  ProxyCardType.loose: 'loose',
  ProxyCardType.standard: 'standard',
  ProxyCardType.compact: 'compact',
};
