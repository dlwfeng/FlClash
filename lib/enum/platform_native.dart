import 'dart:io';
import 'platform.dart';

SupportPlatform get currentPlatform {
  if (Platform.isWindows) return SupportPlatform.Windows;
  if (Platform.isMacOS) return SupportPlatform.MacOS;
  if (Platform.isLinux) return SupportPlatform.Linux;
  if (Platform.isAndroid) return SupportPlatform.Android;
  throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
}
