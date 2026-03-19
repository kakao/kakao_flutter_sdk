import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:web/web.dart';

import '../constants.dart';
import '../model/kakao_navi_params.dart';
import '../navi_platform.dart';

/// @nodoc
class NaviPlatformImpl extends NaviPlatform {
  @override
  Future<bool> isKakaoNaviInstalled() {
    return CommonPlatform.instance.isAppInstalled();
  }

  @override
  Future<void> navigate(KakaoNaviParams params) {
    if (!isMobileWeb()) {
      throw KakaoClientException(
        ClientErrorCause.notSupported,
        'KakaoNavi is only supported on mobile devices.',
      );
    }

    final queryParams = _getQueryParams(params);

    if (isAndroidWeb()) {
      _navigateAndroid(queryParams);
    } else {
      _navigateIos(queryParams);
    }
    return Future.value();
  }

  String _getQueryParams(KakaoNaviParams params) {
    final extras = <String, String>{
      Constants.ka: KakaoSdk.platformInfo.kaHeader,
    }.toEncodedJson();

    return [
      '${Constants.param}=${Uri.encodeComponent(jsonEncode(params))}',
      Constants.apiver,
      '${Constants.appKey}=${KakaoSdk.appKey}',
      '${Constants.extras}=$extras',
    ].join('&');
  }

  void _navigateAndroid(String queryParams) {
    final intent = _makeAndroidIntent(
      KakaoSdk.platform.web.kakaoNaviScheme,
      queryParams,
    );
    window.location.href = intent;
  }

  void _navigateIos(String queryParams) {
    final schemeUrl = '${KakaoSdk.platform.web.kakaoNaviScheme}?$queryParams';
    final fallbackUrl =
        '${KakaoSdk.platform.web.kakaoNaviInstallPage}?$queryParams';

    _navigateWithFallback(schemeUrl, fallbackUrl);
  }

  void _navigateWithFallback(String schemeUrl, String fallbackUrl) {
    final timer = Timer(const Duration(seconds: 5), () {
      window.top?.location.href = fallbackUrl;
    });

    _bindPageHideEvent(timer);
    window.location.href = schemeUrl;
  }

  String _makeAndroidIntent(String scheme, String queries) {
    final url = '$scheme?$queries';
    final fallbackUrl = Uri.encodeComponent(
      '${KakaoSdk.platform.web.kakaoNaviInstallPage}?$queries',
    );

    final intent = [
      'intent:$url#Intent',
      'package=${KakaoSdk.platform.web.kakaoNaviOrigin}',
      'S.browser_fallback_url=$fallbackUrl',
      'end;',
    ].join(';');
    return intent;
  }

  void _bindPageHideEvent(Timer timer) {
    EventListener? listener;

    listener = (Event event) {
      if (!_isPageVisible()) {
        timer.cancel();
        window.removeEventListener('pagehide', listener);
        window.removeEventListener('visibilitychange', listener);
      }
    }.toJS;

    window.addEventListener('pagehide', listener);
    window.addEventListener('visibilitychange', listener);
  }

  bool _isPageVisible() {
    return !document.hidden;
  }
}
