import 'dart:math';
import 'package:fl_clash/models/memory.dart';
import 'package:flutter/foundation.dart';

@immutable
class MemorySnapshot {
  const MemorySnapshot({
    this.app = 0,
    this.coreTotal = 0,
    this.core,
    this.coreInProcess = false,
  });

  final int app;
  final int coreTotal;
  final CoreMemoryStats? core;
  final bool coreInProcess;

  int get total => app + coreTotal;

  int get coreOther => max(0, coreTotal - (core?.runtimeTotal ?? 0));

  /// On Android the Core shares the app process, so its runtime accounting is
  /// carved out of the process RSS instead of added on top of it.
  static MemorySnapshot resolve({
    required int rss,
    required CoreMemoryStats? core,
    required bool coreInProcess,
  }) {
    if (core == null) {
      return MemorySnapshot(app: rss, coreInProcess: coreInProcess);
    }
    if (coreInProcess) {
      final runtime = core.runtimeTotal;
      return MemorySnapshot(
        app: max(0, rss - runtime),
        coreTotal: runtime,
        core: core,
        coreInProcess: true,
      );
    }
    return MemorySnapshot(app: rss, coreTotal: core.rss, core: core);
  }
}

typedef MemoryReader = Future<MemorySnapshot> Function();
