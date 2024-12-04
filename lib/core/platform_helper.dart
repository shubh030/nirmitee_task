import 'dart:io'; // For platform checks on mobile/desktop
import 'package:flutter/foundation.dart'; // For web detection

enum PlatformType { web, mobile, desktop }

class PlatformHelper {
  static PlatformType getPlatformType() {
    if (kIsWeb) {
      return PlatformType.web;
    } else if (Platform.isAndroid || Platform.isIOS) {
      return PlatformType.mobile;
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return PlatformType.desktop;
    } else {
      throw UnsupportedError("Unknown platform");
    }
  }
}
