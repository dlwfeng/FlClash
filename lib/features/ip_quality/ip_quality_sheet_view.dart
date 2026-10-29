import 'package:fl_clash/enum/ip_quality.dart';
import 'package:fl_clash/l10n/context.dart';
import 'package:fl_clash/models/ip_quality.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/widgets/detail_row.dart';
import 'package:material_ui/material_ui.dart';
import 'ip_quality_text_view.dart';
import 'labels.dart';

class IpQualitySheetView extends StatelessWidget {
  const IpQualitySheetView({
    super.key,
    required this.ip,
    required this.quality,
    required this.isLoading,
    required this.hideIp,
    required this.failures,
    required this.onRefresh,
    required this.onHideIp,
  });

  final String ip;
  final IpQuality? quality;
  final bool isLoading, hideIp;
  final List<({IpQualitySource source, IpQualitySourceStatus status})> failures;
  final VoidCallback onRefresh;
  final ValueChanged<bool> onHideIp;

  @override
  Widget build(BuildContext context) {
    final localizations = context.appLocalizations;
    return CommonScaffold(
      title: localizations.outboundIp,
      actions: [
        AppBarActionButton(
          data: IconButtonData(
            glyph: AppGlyphs.refresh,
            tooltip: localizations.ipQualityRetry,
            isLoading: isLoading,
            onPressed: onRefresh,
          ),
        ),
      ],
      body: _IpQualityDetail(
        ip: ip,
        quality: quality,
        isLoading: isLoading,
        hideIp: hideIp,
        failures: failures,
        onHideIp: onHideIp,
      ),
    );
  }
}

class _IpQualityDetail extends StatelessWidget {
  const _IpQualityDetail({
    required this.ip,
    required this.quality,
    required this.isLoading,
    required this.hideIp,
    required this.failures,
    required this.onHideIp,
  });

  /// The optical edge of the xl-radius cards, as in the memory sheet.
  static const _tipInset = 5.0;

  final String ip;
  final IpQuality? quality;
  final bool isLoading, hideIp;
  final List<({IpQualitySource source, IpQualitySourceStatus status})> failures;
  final ValueChanged<bool> onHideIp;

  @override
  Widget build(BuildContext context) {
    final localizations = context.appLocalizations;
    final failed = quality == null && !isLoading;
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(
        bottom: 20 + context.bottomInset,
        top: context.contentTopPadding,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(_tipInset, 8, _tipInset, 0),
          child: Text(
            localizations.detectionTip,
            style: AppTextStyle.body
                .of(context)
                .copyWith(color: context.colorScheme.onSurfaceVariant),
          ),
        ),
        generateSection(
          title: localizations.basicInfo,
          items: [
            DetailRow(
              title: localizations.ipAddress,
              copyText: ip,
              value: IpQualityTextView(
                ip: ip,
                quality: quality,
                hideIp: hideIp,
              ),
            ),
            if (failed)
              DetailRow(
                title: localizations.ipType,
                value: Text(
                  localizations.ipQualityFailed,
                  style: TextStyle(color: context.colorScheme.error),
                ),
              )
            else
              ..._qualityRows(context, quality),
          ],
        ),
        if (!failed)
          generateSection(
            title: localizations.network,
            items: _networkRows(context, quality),
          ),
        if (failed && failures.isNotEmpty)
          generateSection(
            title: localizations.ipQualitySources,
            items: [
              for (final failure in failures)
                DetailRow(
                  title: failure.source.label,
                  value: Text(failure.status.label(context)),
                ),
            ],
          ),
        generateSection(
          title: localizations.other,
          items: [
            DecorationListItem(
              title: Text(localizations.hideIp),
              onPressed: () => onHideIp(!hideIp),
              trailing: CommonSwitch(value: hideIp, onChanged: onHideIp),
            ),
          ],
        ),
      ],
    );
  }

  /// A lookup still running lays out every row it will fill, so the page
  /// keeps its height when the values arrive.
  List<Widget> _qualityRows(BuildContext context, IpQuality? quality) {
    final localizations = context.appLocalizations;
    if (quality == null) {
      return [
        DetailRow(
          title: localizations.ipQualityLevel,
          value: const SkeletonText(width: 40),
        ),
        DetailRow(
          title: localizations.ipType,
          value: const SkeletonText(width: 64),
        ),
        DetailRow(
          title: localizations.ipFlags,
          value: const SkeletonText(width: 40),
        ),
      ];
    }
    final flags = [
      if (quality.isTor) localizations.ipFlagTor,
      if (quality.isAbuser) localizations.ipFlagAbuser,
      if (quality.isVpn) localizations.ipFlagVpn,
      if (quality.isProxy) localizations.ipFlagProxy,
    ];
    return [
      DetailRow(
        title: localizations.ipQualityLevel,
        value: Text(
          quality.level.label(context),
          style: TextStyle(color: quality.level.color(context)),
        ),
      ),
      DetailRow(
        title: localizations.ipType,
        value: Text(quality.type.label(context)),
      ),
      DetailRow(
        title: localizations.ipFlags,
        value: flags.isEmpty
            ? Text(localizations.none)
            : Wrap(
                spacing: 6,
                runSpacing: 4,
                alignment: WrapAlignment.end,
                children: [for (final flag in flags) MetaChip(label: flag)],
              ),
      ),
    ];
  }

  List<Widget> _networkRows(BuildContext context, IpQuality? quality) {
    final localizations = context.appLocalizations;
    Widget valueOf(String? text, {required double width}) =>
        switch ((quality, text)) {
          (null, _) => SkeletonText(width: width),
          (_, final text?) => Text(text),
          _ => const Text('—'),
        };
    final organization = quality?.organization;
    final asn = switch (quality?.asn) {
      final asn? => 'AS$asn',
      null => null,
    };
    return [
      DetailRow(
        title: localizations.ipOrganization,
        copyText: organization,
        value: valueOf(organization, width: 120),
      ),
      DetailRow(
        title: localizations.ipAsn,
        copyText: asn,
        value: valueOf(asn, width: 56),
      ),
      DetailRow(
        title: localizations.ipQualitySource,
        value: valueOf(quality?.source.label, width: 72),
      ),
    ];
  }
}
