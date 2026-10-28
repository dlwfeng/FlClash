import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'traffic_view.dart';
export 'traffic_view.dart' show TrafficDirection;

extension on TrafficDirection {
  num of(Traffic traffic) =>
      this == TrafficDirection.upload ? traffic.up : traffic.down;
}

class SpeedCard extends ConsumerWidget {
  const SpeedCard({super.key, required this.direction});

  final TrafficDirection direction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final traffics = ref.watch(trafficsProvider);
    final total = ref.watch(
      totalTrafficProvider.select((state) => direction.of(state)),
    );
    return SpeedCardView(
      direction: direction,
      samples: [
        for (final traffic in traffics.list) direction.of(traffic).toDouble(),
      ],
      total: total,
      revision: traffics.revision,
    );
  }
}

class NetworkSpeedCard extends ConsumerWidget {
  const NetworkSpeedCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final traffics = ref.watch(trafficsProvider);
    final total = ref.watch(totalTrafficProvider);
    return NetworkSpeedCardView(
      uploads: [for (final traffic in traffics.list) traffic.up.toDouble()],
      downloads: [for (final traffic in traffics.list) traffic.down.toDouble()],
      totalUp: total.up,
      totalDown: total.down,
      revision: traffics.revision,
    );
  }
}
