import 'dart:convert';
import 'dart:io';

import 'package:fl_clash/remote/codec.dart';
import 'package:fl_clash/remote/server.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RemoteControlServer server;
  late HttpClient client;
  var calls = 0;
  var token = 'test-secret';

  setUp(() async {
    calls = 0;
    token = 'test-secret';
    client = HttpClient();
    server = RemoteControlServer(
      secret: () => token,
      allowedOrigins: const {'http://localhost:7357'},
      handleApi: (method, path, body) async {
        calls++;
        if (path == '/api/failure') throw StateError('private file path');
        return {'method': method, 'body': body};
      },
      readAsset: (path) async =>
          path == 'index.html' ? utf8.encode('<html></html>') : null,
    );
    await server.start(port: 0);
  });

  tearDown(() async {
    client.close(force: true);
    await server.close();
  });

  Future<(int, Object?, HttpHeaders)> send(
    String path, {
    String method = 'GET',
    String? secret = 'test-secret',
    String? origin,
    String? host,
    Object? body,
  }) async {
    final request = await client.openUrl(
      method,
      Uri.parse('http://127.0.0.1:${server.boundPort}$path'),
    );
    if (secret != null) request.headers.set('Authorization', 'Bearer $secret');
    if (origin != null) request.headers.set('Origin', origin);
    if (host != null) request.headers.set('Host', host);
    if (body != null) request.write(jsonEncode(body));
    final response = await request.close();
    final text = await response.transform(utf8.decoder).join();
    return (
      response.statusCode,
      text.startsWith('{') ? jsonDecode(text) : text,
      response.headers,
    );
  }

  test(
    'serves the client without exposing the authentication secret',
    () async {
      final (status, body, headers) = await send('/', secret: null);
      expect(status, 200);
      expect(body, '<html></html>');
      expect(headers.contentType?.mimeType, 'text/html');
      expect(calls, 0);
    },
  );

  test('all application endpoints require the current secret', () async {
    expect((await send('/api/state', secret: null)).$1, 401);
    expect((await send('/api/state', secret: 'wrong')).$1, 401);
    expect(calls, 0);
    expect((await send('/api/state')).$1, 200);
    token = 'rotated-secret';
    expect((await send('/api/state')).$1, 401);
    expect((await send('/api/state', secret: token)).$1, 200);
  });

  test('rejects untrusted origins and host headers before dispatch', () async {
    expect(
      (await send('/api/state', origin: 'https://attacker.example')).$1,
      403,
    );
    expect((await send('/api/state', host: 'attacker.example')).$1, 403);
    expect(calls, 0);
    final response = await send('/api/state', origin: 'http://localhost:7357');
    expect(response.$1, 200);
    expect(
      response.$3.value('Access-Control-Allow-Origin'),
      'http://localhost:7357',
    );
  });

  test(
    'mac-mini serves authenticated same-origin Tailscale requests',
    () async {
      final host = 'mac-mini:${server.boundPort}';
      expect((await send('/', host: host, secret: null)).$1, 200);
      expect((await send('/api/state', host: host, secret: null)).$1, 401);
      final response = await send(
        '/api/state',
        host: host,
        origin: 'http://$host',
      );
      expect(response.$1, 200);
      expect(response.$3.value('Access-Control-Allow-Origin'), 'http://$host');
      expect((await send('/api/state', host: 'mac-mini:1')).$1, 403);
      expect(
        (await send('/api/state', host: host, origin: 'http://mac-mini:1')).$1,
        403,
      );
      expect(
        (await send(
          '/api/state',
          host: host,
          origin: 'https://attacker.example',
        )).$1,
        403,
      );
    },
  );

  test('additional hosts explicitly enable a tailnet FQDN and IP', () async {
    await server.close();
    server = RemoteControlServer(
      secret: () => token,
      allowedHosts: const {
        ...RemoteControlServer.defaultHosts,
        'mac-mini.example.ts.net',
        '100.101.102.103',
      },
      handleApi: (_, _, _) async => true,
      readAsset: (_) async => null,
    );
    await server.start(port: 0);
    for (final name in ['mac-mini.example.ts.net', '100.101.102.103']) {
      final host = '$name:${server.boundPort}';
      expect(
        (await send('/api/state', host: host, origin: 'http://$host')).$1,
        200,
      );
    }
    expect(
      (await send(
        '/api/state',
        host: 'other.example.ts.net:${server.boundPort}',
      )).$1,
      403,
    );
  });

  test(
    'CORS preflight requires a trusted origin and never dispatches',
    () async {
      expect(
        (await send(
          '/api/command',
          method: 'OPTIONS',
          secret: null,
          origin: 'http://localhost:7357',
        )).$1,
        204,
      );
      expect(
        (await send(
          '/api/command',
          method: 'OPTIONS',
          secret: null,
          origin: 'null',
        )).$1,
        403,
      );
      expect(calls, 0);
    },
  );

  test('dispatches JSON commands and redacts internal failures', () async {
    final response = await send(
      '/api/command',
      method: 'POST',
      body: {'command': 'restart'},
    );
    expect(response.$2, {
      'data': {
        'method': 'POST',
        'body': {'command': 'restart'},
      },
    });
    final failure = await send('/api/failure');
    expect(failure.$1, 500);
    expect(failure.$2.toString(), isNot(contains('private file path')));
  });

  test('limits request bodies before dispatch', () async {
    final request = await client.postUrl(
      Uri.parse('http://127.0.0.1:${server.boundPort}/api/command'),
    );
    request.headers.set('Authorization', 'Bearer test-secret');
    request.contentLength = RemoteControlServer.maxBodyBytes + 1;
    request.add(List.filled(RemoteControlServer.maxBodyBytes + 1, 32));
    final response = await request.close();
    expect(response.statusCode, 413);
    await response.drain<void>();
    expect(calls, 0);
  });

  test('close is terminal and releases only its own listener', () async {
    final port = server.boundPort!;
    await server.close();
    expect(() => server.start(port: port), throwsStateError);
    final other = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
    await server.close();
    expect(other.port, port);
    await other.close(force: true);
  });

  test('a port conflict never replaces another listener', () async {
    final other = RemoteControlServer(
      secret: () => token,
      handleApi: (_, _, _) async => null,
      readAsset: (_) async => null,
    );
    await expectLater(
      other.start(port: server.boundPort!),
      throwsA(isA<SocketException>()),
    );
    await other.close();
    expect((await send('/api/state')).$1, 200);
  });

  test('wire encoding preserves Snowflake IDs in browser JavaScript', () async {
    final value = jsonDecode(
      await encodeRemoteData({'id': 374813178134532096, 'port': 9091}),
    );
    expect(value, {
      'data': {'id': '374813178134532096', 'port': 9091},
    });
  });
}
