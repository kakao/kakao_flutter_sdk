import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartPackageName: 'kakao_flutter_sdk_common',
    dartOut:
        'packages/kakao_flutter_sdk_common/lib/src/pigeon/common_messages.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'packages/kakao_flutter_sdk_common/android/src/main/kotlin/com/kakao/sdk/flutter/common/CommonMessages.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.kakao.sdk.flutter.common'),
    swiftOut:
        'packages/kakao_flutter_sdk_common/ios/kakao_flutter_sdk_common/Sources/kakao_flutter_sdk_common/CommonMessages.g.swift',
  ),
)
class PlatformData {
  late Uint8List platformId;
  late String origin;

  late String kaHeader;
  late String appVer;
  late String? packageName;
}

@HostApi()
abstract class CommonHostApi {
  PlatformData getPlatformData();

  // android: packageName, ios: appScheme
  bool isAppInstalled(String appIdentifier);

  bool isKakaoTalkAvailable(String? appScheme);

  @async
  void launchUrl(String url, bool useBrowserSession);
}

// / Flutter API for receiving deep link events from native platforms
@FlutterApi()
abstract class CommonFlutterApi {
  void onDeepLinkReceived(String url);
}
