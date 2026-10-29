import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'browser_session.dart';

class RemoteControlClient extends ChangeNotifier {
  RemoteControlClient({Dio? http, String? endpoint})
    : _http = http ?? Dio(),
      endpoint = endpoint ?? _defaultEndpoint() {
    _http.options.connectTimeout = const Duration(seconds: 5);
    secret = readRemoteSecret() ?? '';
  }

  final Dio _http;
  String secret = '';
  Map<String, dynamic>? state;
  Object? error;
  bool busy = false;
  bool _refreshing = false;
  bool _disposed = false;
  final String endpoint;

  static String _defaultEndpoint() {
    const configured = String.fromEnvironment('REMOTE_ENDPOINT');
    if (configured.isNotEmpty) return configured;
    return Uri.base.scheme == 'http' || Uri.base.scheme == 'https'
        ? Uri.base.origin
        : 'http://127.0.0.1:9091';
  }

  Future<Object?> api(String method, String path, [Object? body]) async {
    if (_disposed) throw StateError('Remote client is disposed');
    final response = await _http.request<Map<String, dynamic>>(
      '$endpoint$path',
      data: body,
      options: Options(
        method: method,
        headers: {'Authorization': 'Bearer $secret'},
        sendTimeout: const Duration(seconds: 15),
        receiveTimeout: Duration(seconds: method == 'GET' ? 10 : 180),
      ),
    );
    return response.data?['data'];
  }

  Future<void> refresh() async {
    if (_refreshing || _disposed || secret.isEmpty) return;
    _refreshing = true;
    try {
      final next = await api('GET', '/api/state');
      if (_disposed) return;
      state = Map<String, dynamic>.from(next! as Map);
      error = null;
      storeRemoteSecret(secret);
    } catch (failure) {
      if (!_disposed) error = failure;
    } finally {
      _refreshing = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<Object?> command(
    String command, [
    Map<String, Object?> args = const {},
  ]) {
    return mutate(
      () => api('POST', '/api/command', {'command': command, ...args}),
    );
  }

  Future<Object?> patchSettings(
    String section,
    Object? value,
    Object? expected,
  ) {
    return mutate(() async {
      final result = await api('PATCH', '/api/settings', {
        'section': section,
        'value': value,
        'expected': expected,
      });
      if (section == 'patchClashConfig' &&
          value is Map &&
          value['secret'] is String) {
        secret = value['secret'] as String;
      }
      return result;
    });
  }

  Future<Object?> mutate(Future<Object?> Function() operation) async {
    if (_disposed) throw StateError('Remote client is disposed');
    if (busy) throw StateError('An operation is already in progress');
    busy = true;
    notifyListeners();
    try {
      final result = await operation();
      await refresh();
      return result;
    } finally {
      busy = false;
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _http.close(force: true);
    super.dispose();
  }
}
