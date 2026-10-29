import 'dart:typed_data';
import 'package:dio/dio.dart';

final _http = Dio();

Stream<Uint8List> readCachedIcon(String src) async* {
  final response = await _http.get<List<int>>(
    src,
    options: Options(responseType: ResponseType.bytes),
  );
  if (response.data != null) yield Uint8List.fromList(response.data!);
}
