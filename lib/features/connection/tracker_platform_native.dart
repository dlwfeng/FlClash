import 'package:fl_clash/common/system.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/providers/config.dart';
import 'package:fl_clash/widgets/package_icon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

bool showProcessIcons(WidgetRef ref) => ref.watch(
  patchClashConfigProvider.select(
    (state) =>
        state.findProcessMode == FindProcessMode.always && system.isAndroid,
  ),
);
Widget packageIcon(String name, double size) =>
    PackageIcon(packageName: name, size: size);
