import 'package:fl_clash/l10n/context.dart';
import 'package:fl_clash/models/subscription.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/widgets/chip_title.dart';
import 'package:fl_clash/widgets/last_update_time_text.dart';
import 'package:fl_clash/common/traffic_format.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
final _compact = NumberFormat.compact(locale: 'en');
String _traffic(num bytes) { final value = dashboardTrafficValue(bytes); return '${value.value}${value.unit}'; }

class ExternalProviderItemView extends StatelessWidget {
  final String name, type;
  final int count;
  final DateTime updateAt;
  final SubscriptionInfo? subscriptionInfo;
  final bool isUpdating;
  final VoidCallback? onPressed;

  const ExternalProviderItemView({
    super.key,
    required this.name, required this.type, required this.count, required this.updateAt, required this.subscriptionInfo,
    required this.isUpdating,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final usage = subscriptionInfo?.usage;
    return DecorationListItem(
      onPressed: onPressed,
      title: ChipTitle(
        title: name,
        chip: usage == null ? null : _compact.format(count),
        expire: subscriptionInfo?.expireDate,
      ),
      subtitle: switch ((subscriptionInfo, usage)) {
        (final info?, final usage?) => _TrafficMeter(info: info, usage: usage),
        _ => Text(switch (type) {
          'Proxy' => appLocalizations.proxiesCount(count, _compact.format(count)),
          _ => appLocalizations.rulesCount(count, _compact.format(count)),
        }),
      },
      trailing: AnimatedSwitcher(
        duration: context.motionDuration(commonDuration),
        layoutBuilder: (current, previous) => Stack(
          alignment: Alignment.centerRight,
          children: [...previous, ?current],
        ),
        child: isUpdating
            ? const CommonCircleLoading(key: ValueKey('loading'), size: 24)
            : LastUpdateTimeText(
                key: const ValueKey('time'),
                lastUpdateDate: updateAt.microsecondsSinceEpoch > 0
                    ? updateAt
                    : null,
                compact: true,
                style: context.listCaptionStyle,
              ),
      ),
    );
  }
}

class _TrafficMeter extends StatelessWidget {
  final SubscriptionInfo info;
  final double usage;

  const _TrafficMeter({required this.info, required this.usage});

  @override
  Widget build(BuildContext context) {
    final used = info.upload + info.download;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 6,
      children: [
        Text(
          '${_traffic(used)} / ${_traffic(info.total)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        LinearProgressIndicator(
          minHeight: 4,
          value: usage,
          backgroundColor: context.colorScheme.primary.opacity15,
        ),
      ],
    );
  }
}

class ExternalProvidersSliverView extends StatelessWidget {
  const ExternalProvidersSliverView({super.key, required this.itemCount, required this.itemBuilder, required this.isUpdating, required this.onUpdate});
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final bool isUpdating;
  final VoidCallback onUpdate;
  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: ListHeader(
            title: context.appLocalizations.providers,
            actions: [
              IconButtonData(
                glyph: AppGlyphs.sync,
                tooltip: context.appLocalizations.update,
                isLoading: isUpdating,
                onPressed: onUpdate,
              ),
            ],
          ),
        ),
        SliverList.builder(
          itemCount: itemCount,
          itemBuilder: (_, index) {
            final position = ItemPosition.get(index, itemCount);
            return ItemPositionProvider(
              position: position,
              child: itemBuilder(context, index),
            );
          },
        ),
      ],
    );
  }
}
