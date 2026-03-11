import '../../kakao_flutter_sdk_common.dart';
import '../pigeon/common_messages.g.dart' as pigeon;
import 'common_flutter_api_impl.dart';

/// @nodoc
class CommonPlatformImpl extends CommonPlatform {
  static final pigeon.CommonHostApi _api = pigeon.CommonHostApi();

  @override
  Future<PlatformData> getPlatformData() async {
    final data = await _api.getPlatformData();
    return PlatformData(
      platformId: data.platformId,
      origin: data.origin,
      kaHeader: data.kaHeader,
      appVer: data.appVer,
      packageName: data.packageName,
    );
  }

  @override
  Future<bool> isAppInstalled({String? packageName, String? appScheme}) {
    if (KakaoSdk.platformInfo.isAndroid) {
      // Android
      return _api.isAppInstalled(packageName!);
    } else if (appScheme != null) {
      // iOS
      return _api.isAppInstalled(appScheme);
    }
    throw ArgumentError('packageName or appScheme must be provided');
  }

  @override
  Future<bool> isKakaoTalkAvailable(String? appScheme) {
    // ios, web은 내부에서 isAppInstalled 호출.
    // 안드로이드 톡 유효성 체크를 위해 별도 메소드로 분리
    return _api.isKakaoTalkAvailable(appScheme);
  }

  @override
  Future<void> launchUrl(String url, {bool useBrowserSession = false}) {
    // useBrowserSession은 ios에서만 사용
    return _api.launchUrl(url, useBrowserSession);
  }

  @override
  void setDeepLinkCallback(Function(String url)? callback) {
    if (callback == null) {
      pigeon.CommonFlutterApi.setUp(null);
    } else {
      pigeon.CommonFlutterApi.setUp(CommonFlutterApiImpl(callback));
    }
  }
}
