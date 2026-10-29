import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fl_clash/common/compute.dart';
import 'package:fl_clash/common/optional_string.dart';
import 'package:fl_clash/common/search.dart';
import 'package:fl_clash/enum/proxies.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/proxies.dart';
import 'package:fl_clash/views/proxies/bindings.dart';
import 'package:fl_clash/views/proxies/proxies.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'client.dart';
import 'package:fl_clash/widgets/feedback.dart';

class RemoteProxiesPage extends StatefulWidget {
  const RemoteProxiesPage({
    super.key,
    required this.client,
    this.picker = false,
    this.initialGroup,
  });

  final RemoteControlClient client;
  final bool picker;
  final String? initialGroup;

  @override
  State<RemoteProxiesPage> createState() => _RemoteProxiesPageState();
}

class _RemoteProxiesPageState extends State<RemoteProxiesPage> {
  late final _adapterOverride = proxyPageAdapterProvider.overrideWith(
    (_) { final adapter = RemoteProxyAdapter(
      widget.client,
      localizations: () => AppLocalizations.of(context),
      showError: (message) {
        if (!mounted) return;
        showAppFeedback(context, message, level: MessageLevel.error);
      },
    );
      if (widget.initialGroup case final name?) adapter.updateCurrentGroupName(name);
      return adapter;
    },
  );

  @override
  Widget build(BuildContext context) => ProviderScope(
    key: ObjectKey(widget.client),
    overrides: [_adapterOverride],
    child: ProxiesView(picker: widget.picker),
  );
}

class RemoteProxyAdapter extends ProxyPageAdapter {
  RemoteProxyAdapter(
    this.client, {
    required this.localizations,
    required this.showError,
  }) {
    client.addListener(_refresh);
    _refresh();
  }

  final RemoteControlClient client;
  final AppLocalizations Function() localizations;
  final ValueChanged<String> showError;
  Map<String, dynamic> _state = {};
  Map<String, dynamic> _config = {};
  Map<String, dynamic> _profile = {};
  List<Group> _allGroups = const [];
  List<Group> _groups = const [];
  String _query = '';
  String? _currentGroupName;
  Set<String>? _unfoldSet;
  String? _profileId;
  DelayMap _delays = {};
  final Map<String, DelayTestPhase> _phases = {};
  final Map<String, Timer> _selectionTimers = {};
  final Map<String, String> _pendingSelected = {};
  final Map<String, int> _selectionRevision = {};
  bool _disposed = false;

  static Map<String, dynamic> _map(Object? value) =>
      value is Map ? Map<String, dynamic>.from(value) : {};

  @override
  ProxiesStyleProps get style =>
      ProxiesStyleProps.fromJson(_map(_config['proxiesStyleProps']));
  @override
  String get query => _query;
  @override
  List<Group> get groups => _groups;
  @override
  List<Group> get allGroups => _allGroups;
  @override
  String? get profileId => _profileId;
  @override
  String? get currentGroupName =>
      _currentGroupName ?? _profile['currentGroupName'] as String?;
  @override
  Set<String> get unfoldSet =>
      _unfoldSet ??
      {for (final name in (_profile['unfoldSet'] as List? ?? [])) '$name'};
  @override
  bool get isCustomProfile => _profile['type'] == 'custom';
  @override
  bool get isLoading => _state['ready'] != true;
  @override
  Set<String> get testingGroups => const {};

  Map<String, String> get _selected => {
    for (final entry in _map(_state['selectedMap']).entries)
      entry.key: '${entry.value}',
    ..._pendingSelected,
  };
  String get _defaultTestUrl =>
      (_map(_config['patchClashConfig'])['testUrl'] as String?).takeFirstValid([
        'https://www.gstatic.com/generate_204',
      ]);

  void _refresh() {
    if (_disposed) return;
    _state = client.state ?? {};
    _config = _map(_state['config']);
    final nextProfileId = _config['currentProfileId']?.toString();
    if (nextProfileId != _profileId) {
      _profileId = nextProfileId;
      _currentGroupName = null;
      _unfoldSet = null;
      _query = '';
    }
    _profile = {};
    for (final value in _state['profiles'] as List? ?? []) {
      final profile = _map(value);
      if (profile['id']?.toString() == _profileId) _profile = profile;
    }
    _allGroups = [
      for (final value in _state['groups'] as List? ?? [])
        Group.fromJson(_map(value)),
    ];
    _delays = {
      for (final entry in _map(_state['delays']).entries)
        entry.key: {
          for (final delay in _map(entry.value).entries)
            delay.key: (delay.value as num?)?.toInt(),
        },
    };
    _filter();
    notifyListeners();
  }

  void _filter() {
    final mode = _map(_config['patchClashConfig'])['mode'] ?? 'rule';
    final search = SearchQuery(_query);
    var shown = [
      if (mode != 'direct')
        for (final group in _allGroups)
          if (mode == 'global' || group.hidden == false)
            group.copyWith(
              now: '',
              all: [
                for (final proxy in group.all)
                  if (search.matches(proxy.searchFields))
                    proxy.copyWith(now: ''),
              ],
            ),
    ];
    if (search.isNotEmpty) {
      shown = shown.where((group) => group.all.isNotEmpty).toList();
    }
    if (style.hideTimeoutProxies) {
      shown = computeHideTimeout(
        groups: shown,
        allGroups: _allGroups,
        delayMap: _delays,
        selectedMap: _selected,
        defaultTestUrl: _defaultTestUrl,
      );
    }
    _groups = computeSort(
      groups: shown,
      sortType: style.sortType,
      delayMap: _delays,
      selectedMap: _selected,
      defaultTestUrl: _defaultTestUrl,
    );
  }

  @override
  String? proxyName(String groupName) => _selected[groupName];
  @override
  String? selectedName(String groupName) => _allGroups
      .getGroup(groupName)
      ?.getCurrentSelectedName(proxyName(groupName) ?? '');
  @override
  SelectedProxyState realSelected(String name) => computeRealSelectedProxyState(
    name,
    groups: _allGroups,
    selectedMap: _selected,
  );

  (String, String) _target(String name, String? url) {
    final selected = realSelected(name);
    return (
      selected.proxyName,
      selected.testUrl.takeFirstValid([url, _defaultTestUrl]),
    );
  }

  @override
  int? delay(String name, String? url) {
    final (proxy, testUrl) = _target(name, url);
    return _delays[testUrl]?[proxy];
  }

  @override
  DelayTestPhase? phase(String name, String? url) {
    final (proxy, testUrl) = _target(name, url);
    return _phases[delayTestKey(testUrl, proxy)];
  }

  Future<bool> _run(Future<Object?> Function() operation) async {
    try {
      if (client.error != null || _state['ready'] != true) {
        throw StateError(localizations().remoteConnectionLost);
      }
      final result = await operation();
      if (result == false) {
        throw StateError(localizations().remoteOperationFailed);
      }
      return true;
    } catch (error) {
      if (_disposed) return false;
      showError(
        error is DioException
            ? _map(error.response?.data)['error']?.toString() ??
                  localizations().remoteConnectionLost
            : error is StateError
            ? error.message.toString()
            : error.toString(),
      );
      return false;
    }
  }

  @override
  void updateStyle(ProxiesStyleProps Function(ProxiesStyleProps) update) {
    final expected = _map(_config['proxiesStyleProps']);
    unawaited(
      _run(
        () => client.patchSettings(
          'proxiesStyleProps',
          update(style).toJson(),
          expected,
        ),
      ),
    );
  }

  @override
  void search(String value) {
    _query = value;
    _filter();
    notifyListeners();
  }

  @override
  void selectionWarning() => showError(localizations().notSelectedTip);
  @override
  void changeProxyDebounce(String group, String proxy) {
    _selectionTimers.remove(group)?.cancel();
    final revision = (_selectionRevision[group] ?? 0) + 1;
    _selectionRevision[group] = revision;
    _pendingSelected[group] = proxy;
    notifyListeners();
    _selectionTimers[group] = Timer(const Duration(milliseconds: 600), () {
      _selectionTimers.remove(group);
      unawaited(_select(group, proxy, revision));
    });
  }

  Future<void> _select(String group, String proxy, int revision) async {
    await _run(
      () => client.command('selectProxy', {'group': group, 'proxy': proxy}),
    );
    if (_disposed || _selectionRevision[group] != revision) return;
    _pendingSelected.remove(group);
    notifyListeners();
  }

  @override
  Future<void> delayTestPageGroup(String name) async => showError(
    localizations().remoteFeatureUnavailable(localizations().delayTest),
  );
  @override
  Future<void> proxyDelayTest(Proxy proxy, String? url) async {
    final (name, testUrl) = _target(proxy.name, url);
    final key = delayTestKey(testUrl, name);
    if (_phases.containsKey(key)) return;
    _phases[key] = DelayTestPhase.running;
    notifyListeners();
    try {
      await _run(() async {
        final result = await client.command('delay', {
          'proxy': name,
          'url': testUrl,
        });
        if (!_disposed && result is Map && result.containsKey('value')) {
          _delays = {
            ..._delays,
            testUrl: {
              ...?_delays[testUrl],
              name: (result['value'] as num?)?.toInt(),
            },
          };
        }
        return null;
      });
    } finally {
      _phases.remove(key);
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void updateCurrentGroupName(String name) {
    if (currentGroupName == name) return;
    _currentGroupName = name;
    notifyListeners();
  }

  @override
  void updateCurrentUnfoldSet(Set<String> names) {
    _unfoldSet = Set.of(names);
    notifyListeners();
  }

  @override
  void addToLocalProxies(String name) => showError(
    localizations().remoteFeatureUnavailable(localizations().addToLocalProxies),
  );

  @override
  void dispose() {
    _disposed = true;
    client.removeListener(_refresh);
    for (final timer in _selectionTimers.values) {
      timer.cancel();
    }
    super.dispose();
  }
}
