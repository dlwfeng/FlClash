import 'dart:io';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/state.dart';
import 'package:flutter/foundation.dart';
import 'package:yaml/yaml.dart';

({String md5, ConfigCounts counts})? _countsCache;

// package:yaml holds a document in many times its size.
const _maxCountedConfigBytes = 8 << 20;

ConfigCounts? cachedAppliedConfigCounts() {
  if (globalState.lastConfigCounts case final counts?) {
    return counts;
  }
  final cache = _countsCache;
  final md5 = globalState.lastConfigMd5;
  return cache != null && cache.md5 == md5 ? cache.counts : null;
}

ConfigCounts? _countConfigFile(String path) {
  final file = File(path);
  if (!file.existsSync() || file.lengthSync() > _maxCountedConfigBytes) {
    return null;
  }
  final config = loadYaml(file.readAsStringSync());
  return configCountsOf(config is Map ? config : const {});
}

/// Parsed in an isolate: a large profile takes far longer than a frame.
Future<ConfigCounts?> loadAppliedConfigCounts() async {
  if (cachedAppliedConfigCounts() case final counts?) {
    return counts;
  }
  final md5 = globalState.lastConfigMd5;
  final counts = await compute(_countConfigFile, await appPath.configFilePath);
  if (md5 != null && counts != null) {
    _countsCache = (md5: md5, counts: counts);
  }
  return counts;
}

