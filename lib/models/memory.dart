import 'package:freezed_annotation/freezed_annotation.dart';
part 'generated/memory.freezed.dart';
part 'generated/memory.g.dart';

@freezed
abstract class CoreMemoryStats with _$CoreMemoryStats {
  const factory CoreMemoryStats({
    @Default(0) int rss,
    @Default(0) int heapInuse,
    @Default(0) int heapIdle,
    @Default(0) int stackInuse,
    @Default(0) int runtimeOther,
  }) = _CoreMemoryStats;

  factory CoreMemoryStats.fromJson(Map<String, Object?> json) =>
      _$CoreMemoryStatsFromJson(json);
}

extension CoreMemoryStatsExt on CoreMemoryStats {
  int get runtimeTotal => heapInuse + heapIdle + stackInuse + runtimeOther;
}
