import 'dart:typed_data';

/// @nodoc
class PlatformData {
  const PlatformData({
    required this.platformId,
    required this.origin,
    required this.kaHeader,
    required this.appVer,
    required this.packageName,
  });

  final Uint8List platformId;
  final String origin;
  final String kaHeader;
  final String appVer;
  final String? packageName;
}
