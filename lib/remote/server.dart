import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'codec.dart';

typedef RemoteApiHandler =
    Future<Object?> Function(String method, String path, Object? body);
typedef RemoteAssetReader = Future<List<int>?> Function(String path);

class RemoteApiException implements Exception {
  const RemoteApiException(this.status, this.message);

  final int status;
  final String message;
}

class RemoteControlServer {
  RemoteControlServer({
    required this.secret,
    required this.handleApi,
    required this.readAsset,
    this.allowedOrigins = const {},
    this.allowedHosts = defaultHosts,
    this.onError,
  });

  static const port = 9091;
  static const defaultHosts = {'127.0.0.1', 'localhost', 'mac-mini'};
  static const maxBodyBytes = 8 * 1024 * 1024;
  final String Function() secret;
  final RemoteApiHandler handleApi;
  final RemoteAssetReader readAsset;
  final Set<String> allowedOrigins;
  final Set<String> allowedHosts;
  final void Function(Object error, StackTrace stack)? onError;
  HttpServer? _server;
  Future<void>? _starting;
  bool _closed = false;

  int? get boundPort => _server?.port;

  Future<void> start({int port = RemoteControlServer.port}) {
    if (_closed) throw StateError('Remote server is closed');
    return _starting ??= _bind(port);
  }

  Future<void> _bind(int port) async {
    try {
      final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
      if (_closed) {
        await server.close(force: true);
        return;
      }
      _server = server;
      server.listen(
        (request) => unawaited(_handle(request)),
        onError: (Object error, StackTrace stack) =>
            onError?.call(error, stack),
      );
    } catch (_) {
      _starting = null;
      rethrow;
    }
  }

  Future<void> close() async {
    _closed = true;
    await _starting?.onError((_, _) {});
    await _server?.close(force: true);
    _server = null;
  }

  bool _isTrustedHost(HttpRequest request) {
    final host = request.headers.value(HttpHeaders.hostHeader)?.toLowerCase();
    return allowedHosts.any(
      (allowed) => host == '${allowed.toLowerCase()}:${_server?.port}',
    );
  }

  bool _isTrustedOrigin(HttpRequest request, String origin) {
    return allowedHosts.any(
          (host) => origin == 'http://${host.toLowerCase()}:${_server?.port}',
        ) ||
        allowedOrigins.contains(origin);
  }

  bool _authorized(HttpRequest request) {
    final expected = utf8.encode('Bearer ${secret()}');
    final supplied = utf8.encode(
      request.headers.value(HttpHeaders.authorizationHeader) ?? '',
    );
    if (secret().isEmpty || expected.length != supplied.length) return false;
    var difference = 0;
    for (var i = 0; i < expected.length; i++) {
      difference |= expected[i] ^ supplied[i];
    }
    return difference == 0;
  }

  Future<void> _handle(HttpRequest request) async {
    final response = request.response;
    response.headers
      ..set(HttpHeaders.cacheControlHeader, 'no-store')
      ..set('X-Content-Type-Options', 'nosniff')
      ..set('Referrer-Policy', 'no-referrer')
      ..set('X-Frame-Options', 'DENY');
    try {
      if (!_isTrustedHost(request)) {
        throw const RemoteApiException(403, 'Untrusted host');
      }
      final origin = request.headers.value('Origin');
      if (origin != null) {
        if (!_isTrustedOrigin(request, origin)) {
          throw const RemoteApiException(403, 'Untrusted origin');
        }
        response.headers
          ..set('Access-Control-Allow-Origin', origin)
          ..set('Vary', 'Origin');
      }
      if (request.method == 'OPTIONS') {
        response.headers
          ..set('Access-Control-Allow-Methods', 'GET, POST, PATCH, DELETE')
          ..set('Access-Control-Allow-Headers', 'Authorization, Content-Type');
        response.statusCode = HttpStatus.noContent;
        return;
      }
      final path = request.uri.path;
      if (path.startsWith('/api/')) {
        if (!_authorized(request)) {
          throw const RemoteApiException(401, 'Authentication required');
        }
        final body = await _readBody(request);
        final result = await handleApi(request.method, path, body);
        response.headers.contentType = ContentType.json;
        response.write(await encodeRemoteData(result));
      } else {
        if (request.method != 'GET' && request.method != 'HEAD') {
          throw const RemoteApiException(405, 'Method not allowed');
        }
        if (request.uri.pathSegments.any(
          (segment) => segment == '..' || segment.contains('\\'),
        )) {
          throw const RemoteApiException(400, 'Invalid asset path');
        }
        final asset = path == '/' ? 'index.html' : path.substring(1);
        final bytes = await readAsset(asset);
        if (bytes == null) {
          throw const RemoteApiException(404, 'Web client has not been built');
        }
        response.headers.contentType = _contentType(asset);
        response.contentLength = bytes.length;
        if (request.method != 'HEAD') response.add(bytes);
      }
    } on RemoteApiException catch (error) {
      if (error.status == 413) response.persistentConnection = false;
      response.statusCode = error.status;
      response.headers.contentType = ContentType.json;
      response.write(jsonEncode({'error': error.message}));
    } on FormatException {
      response.statusCode = HttpStatus.badRequest;
      response.headers.contentType = ContentType.json;
      response.write(jsonEncode({'error': 'Invalid JSON request'}));
    } catch (error, stack) {
      onError?.call(error, stack);
      response.statusCode = HttpStatus.internalServerError;
      response.headers.contentType = ContentType.json;
      response.write(jsonEncode({'error': 'Operation failed'}));
    } finally {
      await response.close();
    }
  }

  Future<Object?> _readBody(HttpRequest request) async {
    if (request.contentLength > maxBodyBytes) {
      throw const RemoteApiException(413, 'Request too large');
    }
    final bytes = <int>[];
    await for (final chunk in request.timeout(const Duration(seconds: 15))) {
      if (bytes.length + chunk.length > maxBodyBytes) {
        throw const RemoteApiException(413, 'Request too large');
      }
      bytes.addAll(chunk);
    }
    return bytes.isEmpty ? null : jsonDecode(utf8.decode(bytes));
  }

  static ContentType _contentType(String path) {
    return switch (path.split('.').last) {
      'html' => ContentType.html,
      'js' || 'mjs' => ContentType('text', 'javascript'),
      'css' => ContentType('text', 'css'),
      'json' => ContentType.json,
      'wasm' => ContentType('application', 'wasm'),
      'svg' => ContentType('image', 'svg+xml'),
      'png' => ContentType('image', 'png'),
      'ico' => ContentType('image', 'x-icon'),
      'ttf' => ContentType('font', 'ttf'),
      'woff2' => ContentType('font', 'woff2'),
      _ => ContentType.binary,
    };
  }
}
