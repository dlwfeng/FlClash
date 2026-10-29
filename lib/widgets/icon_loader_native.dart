import 'dart:typed_data';
import 'package:fl_clash/common/cache.dart';
import 'package:fl_clash/common/constant.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

final _cacheManager = CacheManager(
  Config(
    DefaultCacheManager.key,
    fileService: HttpFileService()..concurrentFetches = maxConcurrentIconLoads,
  ),
);

Stream<Uint8List> readCachedIcon(String src) {
  return _cacheManager
      .getFileStreamV2(src)
      .asyncMap((data) => data.file.readAsBytes());
}
