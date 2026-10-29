import 'package:freezed_annotation/freezed_annotation.dart';

enum DnsMode {
  normal,
  @JsonValue('fake-ip')
  fakeIp,
  @JsonValue('redir-host')
  redirHost,
  hosts,
}

enum DnsQueryInitiator { app, rule, direct, proxy, other }
