import 'dart:async';
import 'package:fl_clash/enum/probe.dart';
import 'package:flutter/foundation.dart';

class ProbePhaseHold extends ChangeNotifier {
  Timer? _timer;
  ProbePhase shown(ProbePhase phase) =>
      _timer != null && phase == ProbePhase.failed ? ProbePhase.probing : phase;
  void rearm(bool proxied) {
    _timer?.cancel();
    _timer = proxied
        ? Timer(const Duration(seconds: 5), () {
            _timer = null;
            notifyListeners();
          })
        : null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
