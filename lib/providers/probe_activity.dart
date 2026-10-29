import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

class RemoteProbeClients extends Notifier<int> {
  @override
  int build() => 0;
  void acquire() => state++;
  void release() {
    if (state > 0) state--;
  }
}

final remoteProbeClientsProvider = NotifierProvider<RemoteProbeClients, int>(
  RemoteProbeClients.new,
);
final probeActivityProvider = Provider<bool>(
  (ref) =>
      ref.watch(appVisibleProvider) ||
      ref.watch(remoteProbeClientsProvider) > 0,
);
