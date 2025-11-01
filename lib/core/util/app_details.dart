import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  static String version = 'Unknown';
  static String buildNumber = 'Unknown';

  static Future<void> init() async {
    try {
      final info = await PackageInfo.fromPlatform();
      version = info.version;
      buildNumber = info.buildNumber;
    } catch (e) {
      // don't crash startup if something fails
      debugPrint('⚠️ Failed to load package info: $e');
    }
  }
}