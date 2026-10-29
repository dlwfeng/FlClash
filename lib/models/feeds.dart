import 'package:fl_clash/common/search.dart';
import 'package:fl_clash/enum/dns.dart';
import 'package:fl_clash/enum/dns_labels.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'generated/feeds.freezed.dart';
part 'generated/feeds.g.dart';

@freezed
abstract class Metadata with _$Metadata {
  const factory Metadata({
    @Default(0) int uid,
    @Default('') String network,
    @Default('') String sourceIP,
    @Default('') String sourcePort,
    @Default('') String destinationIP,
    @Default('') String destinationPort,
    @Default('') String host,
    DnsMode? dnsMode,
    @Default('') String process,
    @Default('') String processPath,
    @Default('') String remoteDestination,
    @Default([]) List<String> sourceGeoIP,
    @Default([]) List<String> destinationGeoIP,
    @Default('') String destinationIPASN,
    @Default('') String sourceIPASN,
    @Default('') String specialRules,
    @Default('') String specialProxy,
  }) = _Metadata;

  factory Metadata.fromJson(Map<String, Object?> json) =>
      _$MetadataFromJson(json);
}

@freezed
abstract class TrackerInfo with _$TrackerInfo {
  const factory TrackerInfo({
    required String id,
    @Default(0) int upload,
    @Default(0) int download,
    required DateTime start,
    required Metadata metadata,
    required List<String> chains,
    required String rule,
    required String rulePayload,
    int? downloadSpeed,
    int? uploadSpeed,
  }) = _TrackerInfo;

  factory TrackerInfo.fromJson(Map<String, Object?> json) =>
      _$TrackerInfoFromJson(json);
}

/// Reads the Core's `getConnections` answer.
List<TrackerInfo> trackerInfosOf(Object? data) {
  final connections = data is Map ? data['connections'] : null;
  if (connections is! List) {
    return const [];
  }
  return [
    for (final item in connections.whereType<Map>())
      TrackerInfo.fromJson(Map<String, Object?>.from(item)),
  ];
}

typedef RequestTraffic = ({int upload, int download});

extension TrackerInfoExt on TrackerInfo {
  String get title {
    final host = metadata.host;
    if (host.isNotEmpty) {
      return host;
    }
    return metadata.destinationIP;
  }

  String get progressText {
    final process = metadata.process;
    final uid = metadata.uid;
    if (uid != 0) {
      return '$process($uid)'.trim();
    }
    return process.trim();
  }

  List<String> get searchFields => [
    metadata.network,
    metadata.host,
    metadata.destinationIP,
    metadata.destinationPort,
    metadata.sourceIP,
    metadata.sourcePort,
    metadata.process,
    metadata.processPath,
    metadata.remoteDestination,
    metadata.destinationIPASN,
    ...metadata.destinationGeoIP,
    metadata.specialProxy,
    metadata.specialRules,
    rule,
    rulePayload,
    ...chains,
  ];
}

@freezed
abstract class DnsQuery with _$DnsQuery {
  const factory DnsQuery({
    required String domain,
    required String type,
    @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
    DnsQueryInitiator? initiator,
    @Default('') String upstream,
    @Default(false) bool cached,
    @Default([]) List<String> answers,
    @Default('') String rcode,
    @Default('') String error,
    @Default(0) int delay,
    required DateTime time,
  }) = _DnsQuery;

  factory DnsQuery.fromJson(Map<String, Object?> json) =>
      _$DnsQueryFromJson(json);
}

extension DnsQueryExt on DnsQuery {
  bool get hasFailureRcode => rcode.isNotEmpty && rcode != 'NOERROR';

  bool get isFailed => error.isNotEmpty || hasFailureRcode;

  String get summary => error.isNotEmpty ? error : answers.join(', ');

  List<String> get tags => [type, ...resultTags];

  List<String> get resultTags {
    final initiator = this.initiator;
    return [
      if (initiator != null) initiator.label,
      if (cached) AppLocalizations.current.cache,
      if (hasFailureRcode) rcode,
    ];
  }

  List<String> get searchFields => [
    domain,
    ...tags,
    rcode,
    upstream,
    error,
    ...answers,
  ];
}

@freezed
abstract class TrackerInfosState with _$TrackerInfosState {
  const factory TrackerInfosState({
    @Default([]) List<TrackerInfo> trackerInfos,
    @Default([]) List<String> keywords,
    @Default('') String query,
    @Default(true) bool autoScrollToEnd,
  }) = _TrackerInfosState;
}

final _trackerInfoSearchTexts = Expando<String>();

extension TrackerInfosStateExt on TrackerInfosState {
  bool get isSearching => keywords.isNotEmpty || SearchQuery(query).isNotEmpty;

  List<TrackerInfo> get list {
    final searchQuery = SearchQuery(query);
    if (keywords.isEmpty && searchQuery.isEmpty) {
      return trackerInfos;
    }
    return trackerInfos
        .where(
          (trackerInfo) => keywords.every(
            (keyword) =>
                keyword == trackerInfo.metadata.process ||
                trackerInfo.chains.contains(keyword),
          ),
        )
        .whereMatches(
          searchQuery,
          (trackerInfo) => trackerInfo.searchFields,
          texts: _trackerInfoSearchTexts,
        )
        .toList();
  }
}

@freezed
abstract class DnsQueriesState with _$DnsQueriesState {
  const factory DnsQueriesState({
    @Default([]) List<DnsQuery> dnsQueries,
    @Default([]) List<String> keywords,
    @Default('') String query,
    @Default(true) bool autoScrollToEnd,
  }) = _DnsQueriesState;
}

extension DnsQueriesStateExt on DnsQueriesState {
  bool get isSearching => keywords.isNotEmpty || SearchQuery(query).isNotEmpty;

  List<DnsQuery> get list {
    final searchQuery = SearchQuery(query);
    if (keywords.isEmpty && searchQuery.isEmpty) {
      return dnsQueries;
    }
    return dnsQueries
        .where((dnsQuery) => keywords.every(dnsQuery.tags.contains))
        .whereMatches(searchQuery, (dnsQuery) => dnsQuery.searchFields)
        .toList();
  }
}
