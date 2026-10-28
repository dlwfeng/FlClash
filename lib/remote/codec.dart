import 'dart:convert';
import 'dart:isolate';

Future<String> encodeRemoteData(Object? value) =>
    Isolate.run(() => jsonEncode({'data': _wireValue(value)}));

Object? _wireValue(Object? value) {
  if (value == null || value is String || value is bool) return value;
  if (value is int && value.abs() > 9007199254740991) return '$value';
  if (value is num) return value;
  if (value is List) return value.map(_wireValue).toList();
  if (value is Map) {
    return value.map((key, value) => MapEntry('$key', _wireValue(value)));
  }
  return _wireValue((value as dynamic).toJson());
}
