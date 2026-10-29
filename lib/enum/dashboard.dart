import 'platform.dart';
export 'platform.dart';

enum DashboardWidget {
  currentOutbound,
  networkSpeed,
  outboundMode,
  vpnButton(platforms: [SupportPlatform.Android]),
  networkTakeover(platforms: desktopPlatforms),
  serviceStatus,
  profiles,
  proxyGroups,
  connectionStats,
  intranetIp,
  memoryInfo;

  final List<SupportPlatform> platforms;

  const DashboardWidget({this.platforms = SupportPlatform.values});
}

List<DashboardWidget> mergeDashboardWidgets(
  List<DashboardWidget> saved,
  List<DashboardWidget> shown,
  SupportPlatform platform,
) {
  final result = [...shown];
  var at = 0;
  for (final item in saved) {
    if (item.platforms.contains(platform)) {
      final index = result.indexOf(item);
      if (index != -1) at = index + 1;
    } else {
      result.insert(at++, item);
    }
  }
  return result;
}
