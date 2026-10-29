import 'dart:math';
import 'package:fl_clash/l10n/context.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/widgets/active_polling.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../layout.dart';
import '../style.dart';
import '../format.dart';
import 'card.dart';
import 'memory_snapshot.dart';
import 'memory_native.dart'
    if (dart.library.js_interop) 'memory_web.dart'
    as platform;
export 'memory_snapshot.dart';

Future<MemorySnapshot?> _readMemory(WidgetRef ref, MemoryReader? reader) async {
  try {
    return reader != null ? await reader() : await platform.readSnapshot(ref);
  } catch (error) {
    platform.logFailure('updateMemory', error);
    return null;
  }
}

class MemoryInfo extends ConsumerStatefulWidget {
  final MemoryReader? memoryReader;
  final Future<void> Function()? onRelease;

  const MemoryInfo({super.key, this.memoryReader, this.onRelease});

  @override
  ConsumerState<MemoryInfo> createState() => _MemoryInfoState();
}

class _MemoryInfoState extends ConsumerState<MemoryInfo>
    with WidgetsBindingObserver, ActivePollingMixin<MemoryInfo> {
  final _memoryStateNotifier = ValueNotifier<MemorySnapshot>(
    const MemorySnapshot(),
  );
  var _detailOpen = false;

  @override
  Duration get pollInterval => const Duration(seconds: 2);

  @override
  bool get canPoll => super.canPoll && !_detailOpen;

  @override
  void dispose() {
    _memoryStateNotifier.dispose();
    super.dispose();
  }

  @override
  Future<void> poll(PollGuard isCurrent) async {
    final memory = await _readMemory(ref, widget.memoryReader);
    if (memory == null || !isCurrent()) {
      return;
    }
    _memoryStateNotifier.value = memory;
  }

  // The sheet outlives the card when a resize swaps the dashboard layout, so it
  // reads on its own and the card rests until it closes.
  Future<void> _showDetail() async {
    if (_detailOpen) {
      return;
    }
    _detailOpen = true;
    stopPolling();
    await showSheet(
      context: context,
      builder: (_) => MemoryDetailSheet(
        initial: _memoryStateNotifier.value,
        memoryReader: widget.memoryReader,
        onRelease: widget.onRelease,
      ),
    );
    if (!mounted) {
      return;
    }
    _detailOpen = false;
    restartPolling();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final density = DashboardDensityScope.of(context);
    final mobile = !density.isDesktop;
    final summary = ValueListenableBuilder(
      valueListenable: _memoryStateNotifier,
      builder: (_, memory, _) =>
          _MemorySummary(memory: memory, density: density),
    );
    return DashboardCard(
      semanticLabel: appLocalizations.memoryInfo,
      onTap: mobile ? _showDetail : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: mobile ? MainAxisSize.min : MainAxisSize.max,
        children: [
          DashboardCardHeader(
            glyph: AppGlyphs.memory,
            title: appLocalizations.memoryInfo,
            chevron: mobile,
            trailing: [
              if (!mobile)
                Transform.translate(
                  offset: const Offset(8, 0),
                  child: DashboardIconButton(
                    glyph: AppGlyphs.chevronForward,
                    tooltip: appLocalizations.details(
                      appLocalizations.memoryInfo,
                    ),
                    onPressed: _showDetail,
                  ),
                ),
            ],
          ),
          SizedBox(
            height: mobile
                ? 12
                : density.isCompact
                ? 4
                : 6,
          ),
          if (mobile) summary else Expanded(child: summary),
        ],
      ),
    );
  }
}

class _MemorySummary extends StatelessWidget {
  const _MemorySummary({required this.memory, required this.density});

  final MemorySnapshot memory;
  final DashboardDensity density;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final colorScheme = context.colorScheme;
    final mobile = !density.isDesktop;
    final compact = density.isCompact;
    final total = dashboardTrafficValue(memory.total);
    final figure = mobile ? AppTextStyle.title1 : AppTextStyle.title2;
    final parts = [
      (
        label: appLocalizations.app,
        bytes: memory.app,
        color: colorScheme.primary,
      ),
      (
        label: appLocalizations.core,
        bytes: memory.coreTotal,
        color: DashboardColors.of(context).series2,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: mobile ? MainAxisSize.min : MainAxisSize.max,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: total.value,
                style: DashboardText.figure(context, figure),
              ),
              TextSpan(
                text: ' ${total.unit}',
                style: DashboardText.unit(context, AppTextStyle.footnote),
              ),
            ],
          ),
          maxLines: 1,
        ),
        if (mobile) const SizedBox(height: 14) else const Spacer(),
        _MemoryBar(
          segments: [
            for (final part in parts) (bytes: part.bytes, color: part.color),
          ],
        ),
        SizedBox(height: compact ? 8 : 10),
        Wrap(
          spacing: 16,
          runSpacing: 4,
          children: [
            for (final part in parts)
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                children: [
                  DecoratedBox(
                    decoration: ShapeDecoration(
                      color: part.color,
                      shape: AppShape.circle,
                    ),
                    child: const SizedBox.square(dimension: 8),
                  ),
                  Text(part.label, style: DashboardText.label(context)),
                  Text(
                    '${dashboardTrafficValue(part.bytes).value} ${dashboardTrafficValue(part.bytes).unit}',
                    style: AppTextStyle.footnote
                        .of(context, emphasized: true)
                        .toTabular,
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class MemoryDetailSheet extends ConsumerStatefulWidget {
  const MemoryDetailSheet({
    super.key,
    required this.initial,
    this.memoryReader,
    this.onRelease,
  });

  final MemorySnapshot initial;
  final MemoryReader? memoryReader;
  final Future<void> Function()? onRelease;

  @override
  ConsumerState<MemoryDetailSheet> createState() => _MemoryDetailSheetState();
}

class _MemoryDetailSheetState extends ConsumerState<MemoryDetailSheet>
    with WidgetsBindingObserver, ActivePollingMixin<MemoryDetailSheet> {
  static const _minReleaseFeedback = Duration(milliseconds: 500);

  late MemorySnapshot _snapshot = widget.initial;
  bool _isReleasing = false;

  @override
  Duration get pollInterval => const Duration(seconds: 2);

  @override
  Future<void> poll(PollGuard isCurrent) async {
    final memory = await _readMemory(ref, widget.memoryReader);
    if (memory == null || !isCurrent()) {
      return;
    }
    setState(() => _snapshot = memory);
  }

  /// Resolves to the bytes freed.
  Future<int> _release() async {
    final before = _snapshot.total;
    await (widget.onRelease?.call() ?? platform.requestGc(ref));
    if (!mounted) {
      return 0;
    }
    final memory = await _readMemory(ref, widget.memoryReader);
    if (memory == null || !mounted) {
      return 0;
    }
    setState(() => _snapshot = memory);
    return max(0, before - memory.total);
  }

  Future<void> _handleRelease() async {
    if (_isReleasing) {
      return;
    }
    setState(() => _isReleasing = true);
    final appLocalizations = context.appLocalizations;
    String message;
    var success = true;
    try {
      final (freed, _) = await (
        _release(),
        Future<void>.delayed(_minReleaseFeedback),
      ).wait;
      message = freed > 0
          ? appLocalizations.memoryReleasedSize(
              '${dashboardTrafficValue(freed).value}${dashboardTrafficValue(freed).unit}',
            )
          : appLocalizations.memoryReleased;
    } catch (error) {
      platform.logFailure('releaseMemory', error);
      message = appLocalizations.releaseMemoryFailed;
      success = false;
    }
    if (!mounted) {
      return;
    }
    setState(() => _isReleasing = false);
    platform.showMessage(context, message, success);
  }

  List<Widget> _appItems(
    AppLocalizations appLocalizations,
    MemorySnapshot snapshot,
  ) {
    return [
      _MemoryRow(
        label: appLocalizations.memoryAppResident,
        bytes: snapshot.app,
        total: snapshot.app,
      ),
    ];
  }

  List<Widget> _coreItems(
    AppLocalizations appLocalizations,
    MemorySnapshot snapshot,
  ) {
    final core = snapshot.core;
    if (core == null) {
      return [ListItem(title: Text(appLocalizations.memoryCoreNotRunning))];
    }
    final total = snapshot.coreTotal;
    return [
      _MemoryRow(
        label: appLocalizations.memoryCoreHeapInuse,
        bytes: core.heapInuse,
        total: total,
      ),
      _MemoryRow(
        label: appLocalizations.memoryCoreHeapIdle,
        bytes: core.heapIdle,
        total: total,
      ),
      _MemoryRow(
        label: appLocalizations.memoryCoreStack,
        bytes: core.stackInuse,
        total: total,
      ),
      _MemoryRow(
        label: appLocalizations.memoryCoreRuntime,
        bytes: core.runtimeOther,
        total: total,
      ),
      if (snapshot.coreOther > 0)
        _MemoryRow(
          label: appLocalizations.other,
          bytes: snapshot.coreOther,
          total: total,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return CommonScaffold(
      title: appLocalizations.memoryInfo,
      actions: [
        AppBarActionButton(
          data: IconButtonData(
            glyph: AppGlyphs.broom,
            tooltip: appLocalizations.releaseMemory,
            isLoading: _isReleasing,
            onPressed: _handleRelease,
          ),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(
          top: context.contentTopPadding,
          bottom: 20 + context.bottomInset,
        ),
        children: [
          _MemoryOverview(snapshot: _snapshot),
          _MemorySection(
            title: _snapshot.coreInProcess
                ? appLocalizations.memoryAppShared
                : appLocalizations.app,
            bytes: _snapshot.app,
            items: _appItems(appLocalizations, _snapshot),
          ),
          _MemorySection(
            title: appLocalizations.core,
            bytes: _snapshot.coreTotal,
            contentKey: ValueKey(_snapshot.core != null),
            items: _coreItems(appLocalizations, _snapshot),
          ),
        ],
      ),
    );
  }
}

class _MemorySection extends StatelessWidget {
  const _MemorySection({
    required this.title,
    required this.bytes,
    required this.items,
    this.contentKey,
  });

  final String title;
  final int bytes;
  final List<Widget> items;

  /// A change cross-fades the rows instead of swapping them in place.
  final Key? contentKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListHeader(
          title: title,
          trailing: Text(
            '${dashboardTrafficValue(bytes).value}${dashboardTrafficValue(bytes).unit}',
            style: AppTextStyle.footnote
                .of(context)
                .copyWith(color: context.colorScheme.onSurfaceVariant),
          ),
        ),
        AnimatedSize(
          alignment: Alignment.topCenter,
          duration: context.motionDuration(commonDuration),
          curve: Easing.standard,
          child: FadeThroughBox(
            alignment: Alignment.topCenter,
            child: KeyedSubtree(key: contentKey, child: generateGroup(items)),
          ),
        ),
      ],
    );
  }
}

class _MemoryOverview extends StatelessWidget {
  const _MemoryOverview({required this.snapshot});

  /// The optical edge of the xl-radius cards, not their geometric one.
  static const _inset = 5.0;

  final MemorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final colorScheme = context.colorScheme;
    final total = dashboardTrafficValue(snapshot.total);
    return Padding(
      padding: const EdgeInsets.fromLTRB(_inset, 8, _inset, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appLocalizations.total,
            style: AppTextStyle.headline
                .of(context)
                .copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                total.value,
                style: AppTextStyle.title1
                    .of(context, emphasized: true)
                    .copyWith(color: colorScheme.onSurface),
              ),
              const SizedBox(width: 6),
              Text(
                total.unit,
                style: AppTextStyle.headline
                    .of(context)
                    .copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _MemoryBar(
            segments: [
              (bytes: snapshot.app, color: colorScheme.primary),
              (
                bytes: snapshot.coreTotal,
                color: DashboardColors.of(context).series2,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            snapshot.coreInProcess
                ? appLocalizations.memoryEstimateSharedDesc
                : appLocalizations.memoryEstimateDesc,
            style: AppTextStyle.footnote
                .of(context)
                .copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _MemoryBar extends StatelessWidget {
  const _MemoryBar({required this.segments});

  static const _gap = 2.0;

  final List<({int bytes, Color color})> segments;

  @override
  Widget build(BuildContext context) {
    final duration = context.motionDuration(commonDuration);
    final total = segments.fold(
      0,
      (sum, segment) => sum + max(0, segment.bytes),
    );
    return ClipRSuperellipse(
      borderRadius: AppRadius.full,
      child: SizedBox(
        height: 8,
        child: total == 0
            ? ColoredBox(color: DashboardColors.of(context).tone2)
            : Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final (index, segment) in segments.indexed) ...[
                    if (index > 0)
                      AnimatedContainer(
                        duration: duration,
                        curve: Easing.standard,
                        width:
                            segment.bytes > 0 &&
                                segments
                                    .take(index)
                                    .any((previous) => previous.bytes > 0)
                            ? _gap
                            : 0,
                      ),
                    // Whole percents, so the drift between two polls does not
                    // replay the animation every time.
                    TweenAnimationBuilder<double>(
                      tween: Tween(
                        end: (max(0, segment.bytes) * 100 / total)
                            .roundToDouble(),
                      ),
                      duration: duration,
                      curve: Easing.standard,
                      builder: (_, percent, child) => Expanded(
                        flex: (percent * 100).round(),
                        child: child!,
                      ),
                      child: ColoredBox(color: segment.color),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}

class _MemoryRow extends StatelessWidget {
  const _MemoryRow({
    required this.label,
    required this.bytes,
    required this.total,
  });

  final String label;
  final int bytes;
  final int total;

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0 : bytes * 100 / total;
    return ListItem(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 20,
        children: [
          Flexible(child: Text(label)),
          Text(
            '${percent.toStringAsFixed(1).replaceFirst(RegExp(r'\.0$'), '')}%',
            style: AppTextStyle.subheadline
                .of(context)
                .copyWith(color: context.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
