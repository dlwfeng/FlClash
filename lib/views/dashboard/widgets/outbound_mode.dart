import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'outbound_mode_view.dart';

void _changeMode(WidgetRef ref, DashboardMode mode) {
  final value = Mode.values.byName(mode.name);
  if (ref.read(patchClashConfigProvider).mode == value) return;
  ref.read(setupActionProvider.notifier).changeMode(value);
}

class OutboundModeCard extends ConsumerWidget {
  const OutboundModeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(
      patchClashConfigProvider.select((state) => state.mode),
    );
    return OutboundModeCardView(
      mode: DashboardMode.values.byName(mode.name),
      onChanged: (mode) => _changeMode(ref, mode),
    );
  }
}

class OutboundModeBar extends ConsumerWidget {
  const OutboundModeBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(
      patchClashConfigProvider.select((state) => state.mode),
    );
    return OutboundModeBarView(
      mode: DashboardMode.values.byName(mode.name),
      onChanged: (mode) => _changeMode(ref, mode),
    );
  }
}
