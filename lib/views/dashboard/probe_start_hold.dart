import 'probe_phase_hold.dart';

import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/providers/routed_probe.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin ProbeStartHold<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  final _phaseHold = ProbePhaseHold();
  ProbePhase shownPhase(ProbeEntry<Object?> entry) =>
      _phaseHold.shown(entry.phase);
  void _changed() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _phaseHold.addListener(_changed);
    ref.listenManual(
      routeTrackerProvider.select((state) => state.proxied),
      (_, proxied) => _phaseHold.rearm(proxied),
    );
  }

  @override
  void dispose() {
    _phaseHold.dispose();
    super.dispose();
  }
}
