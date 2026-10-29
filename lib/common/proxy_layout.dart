import 'package:fl_clash/ui/navigation_frame.dart';
import 'dart:math';
import 'package:fl_clash/enum/proxies.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:flutter/widgets.dart';

int getProxiesColumns(double viewWidth, ProxiesLayout proxiesLayout) {
  final columns = max((viewWidth / 250).ceil(), 2);
  return switch (proxiesLayout) {
    ProxiesLayout.tight => columns + 1,
    ProxiesLayout.standard => columns,
    ProxiesLayout.loose => columns - 1,
  };
}

double cardSpacingOf(BuildContext context, ViewMode viewMode) =>
    switch (viewMode) {
      ViewMode.mobile => 8.0,
      ViewMode.laptop => 12.0,
      ViewMode.desktop => 16.0,
    }.mAp(context);
ViewMode getViewMode(double viewWidth) {
  if (viewWidth <= mobileNavigationMaxWidth) return ViewMode.mobile;
  if (viewWidth <= compactNavigationMaxWidth) return ViewMode.laptop;
  return ViewMode.desktop;
}
