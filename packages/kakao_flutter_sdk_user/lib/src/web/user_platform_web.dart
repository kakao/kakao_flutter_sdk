import 'dart:async';
import 'dart:convert';

import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import 'package:web/web.dart';

import '../constants.dart';
import '../user_platform.dart';

/// @nodoc
class UserPlatformImpl extends UserPlatform {
  @override
  Future<int> selectShippingAddress({
    bool? mobileView,
    bool? enableBackButton,
  }) async {
    final userAgent = window.navigator.userAgent;
    final browser = BrowserDetector.detect(userAgent);

    if ({Browser.facebook, Browser.instagram}.contains(browser)) {
      throw KakaoAppsException(
        AppsErrorCause.unsupported,
        'unsupported environment.',
      );
    }

    final agt = await AuthApi.instance.agt();

    final response = await _getAppsResponse(
      browser,
      agt,
      mobileView,
      enableBackButton,
    );
    final result = jsonDecode(response);

    if (result[Constants.status] == Constants.error) {
      throw KakaoAppsException.fromJson(result);
    }
    return result[Constants.addressId];
  }

  Future<String> _getAppsResponse(
    Browser browser,
    String agt,
    bool? mobileView,
    bool? enableBackButton,
  ) async {
    final transId = generateRandomString(20);

    final continueUrl = _createSelectShippingAddressUrl(
      transId,
      mobileView,
      enableBackButton,
    );
    final kpidtUrl = _createKpidtUrl(agt, continueUrl);
    return AuthPlatform.instance.handleAppsUrl(
      kpidtUrl,
      transId: transId,
      popupTitle: 'select_shipping_addresses',
    );
  }

  String _createSelectShippingAddressUrl(
    String transId,
    bool? mobileView,
    bool? enableBackButton,
  ) {
    final params = <String, String>{
      Constants.appKey: KakaoSdk.appKey,
      Constants.ka: KakaoSdk.platformInfo.kaHeader,
      Constants.transId: transId,
      Constants.mobileView: ?mobileView?.toString(),
      Constants.enableBackButton: ?enableBackButton?.toString(),
    };

    return Uri(
      scheme: 'https',
      host: KakaoSdk.hosts.apps,
      path: Constants.selectShippingAddressPath,
      query: params.toQuery(),
    ).toString();
  }

  String _createKpidtUrl(String agt, String continueUrl) {
    final params = <String, String>{
      Constants.appKey: KakaoSdk.appKey,
      Constants.agt: agt,
      Constants.continueUrl: continueUrl,
    };

    return Uri(
      scheme: 'https',
      host: KakaoSdk.hosts.apps,
      path: Constants.kpidtPath,
      query: params.toQuery(),
    ).toString();
  }
}
