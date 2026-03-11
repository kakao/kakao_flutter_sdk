import 'dart:convert';

import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

import '../constants.dart';
import '../model/kakao_navi_params.dart';
import '../navi_platform.dart';

/// @nodoc
class NaviPlatformImpl extends NaviPlatform {
  @override
  Future<bool> isKakaoNaviInstalled() {
    return CommonPlatform.instance.isAppInstalled(
      packageName: KakaoSdk.platform.kakaoNaviPackage,
      appScheme: KakaoSdk.platform.kakaoNaviScheme,
    );
  }

  @override
  Future<void> navigate(KakaoNaviParams params) {
    final url =
        '${KakaoSdk.platform.kakaoNaviScheme}?${_getQueryParams(params)}';
    return CommonPlatform.instance.launchUrl(url.toString());
  }

  String _getQueryParams(KakaoNaviParams params) {
    return [
      '${Constants.param}=${Uri.encodeComponent(jsonEncode(params))}',
      Constants.apiver,
      '${Constants.appKey}=${KakaoSdk.appKey}',
      '${Constants.extras}=${_getExtras().toEncodedJson()}',
    ].join('&');
  }

  Map<String, String> _getExtras() {
    final extras = <String, String>{
      Constants.ka: KakaoSdk.platformInfo.kaHeader,
    };

    if (KakaoSdk.platformInfo.isAndroid) {
      extras[Constants.appPkg] = KakaoSdk.platformInfo.packageName!;
      extras[Constants.keyHash] = KakaoSdk.platformInfo.origin;
    } else {
      extras[Constants.appPkg] = KakaoSdk.platformInfo.origin;
    }
    return Map.from(extras);
  }
}
