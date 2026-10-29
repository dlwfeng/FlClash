// ignore_for_file: constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

enum GroupType {
  @JsonValue('select')
  Selector('select'),
  @JsonValue('url-test')
  URLTest('url-test'),
  @JsonValue('fallback')
  Fallback('fallback'),
  @JsonValue('load-balance')
  LoadBalance('load-balance'),
  @JsonValue('relay')
  Relay('relay');

  final String value;

  const GroupType(this.value);

  static GroupType parse(String type) {
    return switch (type.toLowerCase()) {
      'url-test' || 'urltest' => URLTest,
      'select' || 'selector' => Selector,
      'fallback' => Fallback,
      'load-balance' || 'loadbalance' => LoadBalance,
      'relay' => Relay,
      String() => throw UnimplementedError(),
    };
  }

  /// The core refuses a relay group, so it stays parseable but unofferable.
  static List<GroupType> get selectableValues =>
      values.where((item) => item != Relay).toList();
}

extension GroupTypeExtension on GroupType {
  static List<String> get valueList =>
      GroupType.values.map((e) => e.toString().split('.').last).toList();

  bool get isComputedSelected {
    return [GroupType.URLTest, GroupType.Fallback].contains(this);
  }

  static GroupType? getGroupType(String value) {
    final index = GroupTypeExtension.valueList.indexOf(value);
    if (index == -1) return null;
    return GroupType.values[index];
  }
}

enum DelayTestPhase { queued, running }

enum ViewMode { mobile, laptop, desktop }

enum ProxiesSortType { none, delay, name }

enum ProxiesType { tab, list }

enum ProxiesLayout { loose, standard, tight }

enum ProxyCardType { loose, standard, compact }

enum ProxiesIconStyle { filled, plain, hidden }
