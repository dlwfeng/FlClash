// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../common.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Package _$PackageFromJson(Map<String, dynamic> json) => _Package(
  packageName: json['packageName'] as String,
  label: json['label'] as String,
  system: json['system'] as bool,
  internet: json['internet'] as bool,
  lastUpdateTime: (json['lastUpdateTime'] as num).toInt(),
);

Map<String, dynamic> _$PackageToJson(_Package instance) => <String, dynamic>{
  'packageName': instance.packageName,
  'label': instance.label,
  'system': instance.system,
  'internet': instance.internet,
  'lastUpdateTime': instance.lastUpdateTime,
};

_Log _$LogFromJson(Map<String, dynamic> json) => _Log(
  logLevel:
      $enumDecodeNullable(_$LogLevelEnumMap, json['LogLevel']) ?? LogLevel.info,
  payload: json['Payload'] as String? ?? '',
  dateTime: _logDateTime(json['dateTime']),
);

Map<String, dynamic> _$LogToJson(_Log instance) => <String, dynamic>{
  'LogLevel': _$LogLevelEnumMap[instance.logLevel]!,
  'Payload': instance.payload,
  'dateTime': instance.dateTime,
};

const _$LogLevelEnumMap = {
  LogLevel.debug: 'debug',
  LogLevel.info: 'info',
  LogLevel.warning: 'warning',
  LogLevel.error: 'error',
  LogLevel.silent: 'silent',
};

_DAVProps _$DAVPropsFromJson(Map<String, dynamic> json) => _DAVProps(
  uri: json['uri'] as String,
  user: json['user'] as String,
  password: json['password'] == null
      ? ''
      : _decodeDavPassword(json['password'] as String?),
  fileName: json['fileName'] as String? ?? defaultDavFileName,
);

Map<String, dynamic> _$DAVPropsToJson(_DAVProps instance) => <String, dynamic>{
  'uri': instance.uri,
  'user': instance.user,
  'password': _encodeDavPassword(instance.password),
  'fileName': instance.fileName,
};

_Traffic _$TrafficFromJson(Map<String, dynamic> json) =>
    _Traffic(up: json['up'] as num? ?? 0, down: json['down'] as num? ?? 0);

Map<String, dynamic> _$TrafficToJson(_Traffic instance) => <String, dynamic>{
  'up': instance.up,
  'down': instance.down,
};

_HotKeyAction _$HotKeyActionFromJson(Map<String, dynamic> json) =>
    _HotKeyAction(
      action: $enumDecode(_$HotActionEnumMap, json['action']),
      key: (json['key'] as num?)?.toInt(),
      modifiers:
          (json['modifiers'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$KeyboardModifierEnumMap, e))
              .toSet() ??
          const {},
    );

Map<String, dynamic> _$HotKeyActionToJson(_HotKeyAction instance) =>
    <String, dynamic>{
      'action': _$HotActionEnumMap[instance.action]!,
      'key': instance.key,
      'modifiers': instance.modifiers
          .map((e) => _$KeyboardModifierEnumMap[e]!)
          .toList(),
    };

const _$HotActionEnumMap = {
  HotAction.start: 'start',
  HotAction.view: 'view',
  HotAction.mode: 'mode',
  HotAction.proxy: 'proxy',
  HotAction.tun: 'tun',
  HotAction.ruleMode: 'ruleMode',
  HotAction.globalMode: 'globalMode',
  HotAction.directMode: 'directMode',
  HotAction.delayTest: 'delayTest',
  HotAction.updateProfiles: 'updateProfiles',
  HotAction.copyEnv: 'copyEnv',
  HotAction.exit: 'exit',
};

const _$KeyboardModifierEnumMap = {
  KeyboardModifier.alt: 'alt',
  KeyboardModifier.capsLock: 'capsLock',
  KeyboardModifier.control: 'control',
  KeyboardModifier.fn: 'fn',
  KeyboardModifier.meta: 'meta',
  KeyboardModifier.shift: 'shift',
};

_Script _$ScriptFromJson(Map<String, dynamic> json) => _Script(
  id: (json['id'] as num).toInt(),
  label: json['label'] as String,
  lastUpdateTime: DateTime.parse(json['lastUpdateTime'] as String),
  url: json['url'] as String?,
  order: (json['order'] as num?)?.toInt(),
);

Map<String, dynamic> _$ScriptToJson(_Script instance) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'lastUpdateTime': instance.lastUpdateTime.toIso8601String(),
  'url': instance.url,
  'order': instance.order,
};

_IconSetIcon _$IconSetIconFromJson(Map<String, dynamic> json) =>
    _IconSetIcon(name: json['name'] as String, url: json['url'] as String);

Map<String, dynamic> _$IconSetIconToJson(_IconSetIcon instance) =>
    <String, dynamic>{'name': instance.name, 'url': instance.url};
