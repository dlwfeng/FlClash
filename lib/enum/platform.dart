// ignore_for_file: constant_identifier_names
import 'platform_native.dart'
    if (dart.library.js_interop) 'platform_web.dart'
    as detector;

enum SupportPlatform {
  Windows,
  MacOS,
  Linux,
  Android;

  static SupportPlatform get currentPlatform => detector.currentPlatform;
}

const desktopPlatforms = [
  SupportPlatform.Linux,
  SupportPlatform.MacOS,
  SupportPlatform.Windows,
];
