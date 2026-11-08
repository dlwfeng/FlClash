import 'package:fl_clash/common/system.dart';

/// The module ships on the mobile build first. The desktop item and the Web
/// entry stay hidden until this also reports the desktop, and the Core no
/// longer skips the node's injection there.
bool get tailscaleModuleAvailable => system.isAndroid;
