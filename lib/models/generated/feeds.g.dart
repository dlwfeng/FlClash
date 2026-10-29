// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../feeds.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Metadata _$MetadataFromJson(Map<String, dynamic> json) => _Metadata(
  uid: (json['uid'] as num?)?.toInt() ?? 0,
  network: json['network'] as String? ?? '',
  sourceIP: json['sourceIP'] as String? ?? '',
  sourcePort: json['sourcePort'] as String? ?? '',
  destinationIP: json['destinationIP'] as String? ?? '',
  destinationPort: json['destinationPort'] as String? ?? '',
  host: json['host'] as String? ?? '',
  dnsMode: $enumDecodeNullable(_$DnsModeEnumMap, json['dnsMode']),
  process: json['process'] as String? ?? '',
  processPath: json['processPath'] as String? ?? '',
  remoteDestination: json['remoteDestination'] as String? ?? '',
  sourceGeoIP:
      (json['sourceGeoIP'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  destinationGeoIP:
      (json['destinationGeoIP'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  destinationIPASN: json['destinationIPASN'] as String? ?? '',
  sourceIPASN: json['sourceIPASN'] as String? ?? '',
  specialRules: json['specialRules'] as String? ?? '',
  specialProxy: json['specialProxy'] as String? ?? '',
);

Map<String, dynamic> _$MetadataToJson(_Metadata instance) => <String, dynamic>{
  'uid': instance.uid,
  'network': instance.network,
  'sourceIP': instance.sourceIP,
  'sourcePort': instance.sourcePort,
  'destinationIP': instance.destinationIP,
  'destinationPort': instance.destinationPort,
  'host': instance.host,
  'dnsMode': _$DnsModeEnumMap[instance.dnsMode],
  'process': instance.process,
  'processPath': instance.processPath,
  'remoteDestination': instance.remoteDestination,
  'sourceGeoIP': instance.sourceGeoIP,
  'destinationGeoIP': instance.destinationGeoIP,
  'destinationIPASN': instance.destinationIPASN,
  'sourceIPASN': instance.sourceIPASN,
  'specialRules': instance.specialRules,
  'specialProxy': instance.specialProxy,
};

const _$DnsModeEnumMap = {
  DnsMode.normal: 'normal',
  DnsMode.fakeIp: 'fake-ip',
  DnsMode.redirHost: 'redir-host',
  DnsMode.hosts: 'hosts',
};

_TrackerInfo _$TrackerInfoFromJson(Map<String, dynamic> json) => _TrackerInfo(
  id: json['id'] as String,
  upload: (json['upload'] as num?)?.toInt() ?? 0,
  download: (json['download'] as num?)?.toInt() ?? 0,
  start: DateTime.parse(json['start'] as String),
  metadata: Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
  chains: (json['chains'] as List<dynamic>).map((e) => e as String).toList(),
  rule: json['rule'] as String,
  rulePayload: json['rulePayload'] as String,
  downloadSpeed: (json['downloadSpeed'] as num?)?.toInt(),
  uploadSpeed: (json['uploadSpeed'] as num?)?.toInt(),
);

Map<String, dynamic> _$TrackerInfoToJson(_TrackerInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'upload': instance.upload,
      'download': instance.download,
      'start': instance.start.toIso8601String(),
      'metadata': instance.metadata,
      'chains': instance.chains,
      'rule': instance.rule,
      'rulePayload': instance.rulePayload,
      'downloadSpeed': instance.downloadSpeed,
      'uploadSpeed': instance.uploadSpeed,
    };

_DnsQuery _$DnsQueryFromJson(Map<String, dynamic> json) => _DnsQuery(
  domain: json['domain'] as String,
  type: json['type'] as String,
  initiator: $enumDecodeNullable(
    _$DnsQueryInitiatorEnumMap,
    json['initiator'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
  upstream: json['upstream'] as String? ?? '',
  cached: json['cached'] as bool? ?? false,
  answers:
      (json['answers'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  rcode: json['rcode'] as String? ?? '',
  error: json['error'] as String? ?? '',
  delay: (json['delay'] as num?)?.toInt() ?? 0,
  time: DateTime.parse(json['time'] as String),
);

Map<String, dynamic> _$DnsQueryToJson(_DnsQuery instance) => <String, dynamic>{
  'domain': instance.domain,
  'type': instance.type,
  'initiator': _$DnsQueryInitiatorEnumMap[instance.initiator],
  'upstream': instance.upstream,
  'cached': instance.cached,
  'answers': instance.answers,
  'rcode': instance.rcode,
  'error': instance.error,
  'delay': instance.delay,
  'time': instance.time.toIso8601String(),
};

const _$DnsQueryInitiatorEnumMap = {
  DnsQueryInitiator.app: 'app',
  DnsQueryInitiator.rule: 'rule',
  DnsQueryInitiator.direct: 'direct',
  DnsQueryInitiator.proxy: 'proxy',
  DnsQueryInitiator.other: 'other',
};
