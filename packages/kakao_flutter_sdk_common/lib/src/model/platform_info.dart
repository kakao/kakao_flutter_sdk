import 'package:flutter/foundation.dart';

import '../common_platform.dart';

/// @nodoc
class PlatformInfo {
  final String appVer;
  final String kaHeader;
  final String origin;
  final Uint8List platformId;
  final String? packageName; // only for Android

  bool get isAndroid => packageName != null;

  const PlatformInfo._({
    required this.origin,
    required this.kaHeader,
    required this.appVer,
    required this.platformId,
    required this.packageName,
  });

  static Future<PlatformInfo> create({
    required String sdkVersion,
    CommonPlatform? platform,
  }) async {
    final commonPlatform = platform ?? CommonPlatform.instance;

    final data = await commonPlatform.getPlatformData();
    final kaHeader =
        'sdk/$sdkVersion sdk_type/flutter ${data.kaHeader} app_ver/${data.appVer}';

    return PlatformInfo._(
      origin: data.origin,
      kaHeader: kaHeader,
      appVer: data.appVer,
      platformId: data.platformId,
      packageName: data.packageName,
    );
  }
}
