import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import 'package:kakao_flutter_sdk_user/src/constants.dart';
import 'package:kakao_flutter_sdk_user/src/model/user_revoked_service_terms.dart';
import 'package:kakao_flutter_sdk_user/src/model/user_service_terms.dart';

import 'model/access_token_info.dart';
import 'model/scope_info.dart';
import 'model/user.dart';
import 'model/user_id_response.dart';
import 'model/user_shipping_addresses.dart';

/// KO: 카카오 로그인 API 클래스
/// <br>
/// EN: Class for the Kakao Login APIs
class UserApi {
  /// @nodoc
  UserApi(this._dio);

  /// @nodoc
  final Dio _dio;

  static final UserApi instance = UserApi(AuthApiFactory.authApi);

  /// @nodoc
  static const MethodChannel _channel =
      MethodChannel(CommonConstants.methodChannel);

  /// KO: 카카오톡으로 로그인<br>
  /// [channelPublicIds]에 카카오톡 채널 프로필 ID 전달<br>
  /// [serviceTerms] 서비스 약관 목록 전달<br>
  /// <br>
  /// EN: Login with Kakao Talk<br>
  /// Pass Kakao Talk Channel's profile IDs to [channelPublicIds]<br>
  /// Pass List of service terms to [serviceTerms]
  Future<OAuthToken> loginWithKakaoTalk({
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
    String? nonce,
  }) async {
    var codeVerifier = AuthCodeClient.codeVerifier();

    String? stateToken;
    String? redirectUrl;
    if (kIsWeb) {
      stateToken = generateRandomString(20);
      redirectUrl = await AuthCodeClient.instance.platformRedirectUri();
    }

    final authCode = await AuthCodeClient.instance.authorizeWithTalk(
      redirectUri: redirectUrl ?? KakaoSdk.redirectUri,
      channelPublicId: channelPublicIds,
      serviceTerms: serviceTerms,
      codeVerifier: codeVerifier,
      nonce: nonce,
      stateToken: stateToken,
      webPopupLogin: true,
    );

    final token = await AuthApi.instance.issueAccessToken(
        redirectUri: redirectUrl,
        authCode: authCode,
        codeVerifier: codeVerifier);
    await TokenManagerProvider.instance.manager.setToken(token);
    return token;
  }

  /// KO: 카카오계정으로 로그인<br>
  /// [prompts]에 상호작용 추가 요청 프롬프트 전달<br>
  /// [channelPublicIds]에 카카오톡 채널 프로필 ID 전달<br>
  /// [serviceTerms] 서비스 약관 목록 전달<br>
  /// [loginHint]에 카카오계정 로그인 페이지의 ID란에 자동 입력할 값 전달<br>
  /// ID 토큰 재생 공격 방지를 위한 검증 값, 임의의 문자열은 [nonce]에 전달<br>
  /// <br>
  /// EN: Login with Kakao Account<br>
  /// Pass the prompts to [prompts] for requests to add interactions<br>
  /// Pass Kakao Talk Channel's profile IDs to [channelPublicIds]<br>
  /// Pass List of service terms to [serviceTerms]<br>
  /// Pass a value to fill in the ID field of the Kakao Account login page to [loginHint]<br>
  /// Pass a random string to prevent replay attacks to [nonce]
  Future<OAuthToken> loginWithKakaoAccount({
    List<Prompt>? prompts,
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
    String? loginHint,
    String? nonce,
  }) async {
    final codeVerifier = AuthCodeClient.codeVerifier();
    final redirectUri = kIsWeb
        ? CommonConstants.webAccountLoginRedirectUri
        : KakaoSdk.redirectUri;

    final authCode = await AuthCodeClient.instance.authorize(
      redirectUri: redirectUri,
      prompts: prompts,
      channelPublicIds: channelPublicIds,
      serviceTerms: serviceTerms,
      codeVerifier: codeVerifier,
      loginHint: loginHint,
      nonce: nonce,
      webPopupLogin: true,
    );
    final token = await AuthApi.instance.issueAccessToken(
      authCode: authCode,
      codeVerifier: codeVerifier,
      redirectUri: redirectUri,
    );
    await TokenManagerProvider.instance.manager.setToken(token);
    return token;
  }

  /// KO: 추가 항목 동의 받기<br>
  /// 동의 항목 ID 목록은 [scopes]에 전달<br>
  /// <br>
  /// EN: Request additional consent<br>
  /// Pass a list of the scope IDs to [scopes]
  Future<OAuthToken> loginWithNewScopes(List<String> scopes,
      {String? nonce}) async {
    String codeVerifier = AuthCodeClient.codeVerifier();
    final redirectUri = kIsWeb
        ? CommonConstants.webAccountLoginRedirectUri
        : KakaoSdk.redirectUri;

    final authCode = await AuthCodeClient.instance.authorizeWithNewScopes(
      redirectUri: redirectUri,
      scopes: scopes,
      codeVerifier: codeVerifier,
      nonce: nonce,
      webPopupLogin: true,
    );
    final token = await AuthApi.instance.issueAccessToken(
      authCode: authCode,
      codeVerifier: codeVerifier,
      redirectUri: redirectUri,
    );
    await TokenManagerProvider.instance.manager.setToken(token);
    return token;
  }

  /// KO: 사용자 정보 가져오기
  /// <br>
  /// EN: Retrieve user information
  Future<User> me(
      {List<String>? properties, bool secureResource = true}) async {
    var params = {
      Constants.propertyKeys:
          properties != null ? jsonEncode(properties) : null,
      Constants.secureResource: secureResource,
    };
    params.removeWhere((k, v) => v == null);

    return ApiFactory.handleApiError(() async {
      Response response =
          await _dio.get(Constants.v2MePath, queryParameters: params);
      return User.fromJson(response.data);
    });
  }

  /// KO: 로그아웃
  /// <br>
  /// EN: Logout
  Future<UserIdResponse> logout() async {
    return ApiFactory.handleApiError(() async {
      try {
        Response response = await _dio.post(Constants.v1LogoutPath);
        return UserIdResponse.fromJson(response.data);
      } catch (e) {
        rethrow;
      } finally {
        await TokenManagerProvider.instance.manager.clear();
      }
    });
  }

  /// KO: 연결 끊기
  /// <br>
  /// EN: Unlink
  Future<UserIdResponse> unlink() async {
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.post(Constants.v1UnlinkPath);
      await TokenManagerProvider.instance.manager.clear();
      return UserIdResponse.fromJson(response.data);
    });
  }

  /// KO: 액세스 토큰 정보
  /// <br>
  /// EN: Access token information
  Future<AccessTokenInfo> accessTokenInfo() async {
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.get(Constants.v1AccessTokenInfoPath);
      return AccessTokenInfo.fromJson(response.data);
    });
  }

  /// KO: 배송지 선택하기<br>
  /// [enableBackButton]과 [mobileView]는 웹 플랫폼 전용 파라미터<br>
  /// [mobileView]로 배송지 피커를 모바일 디바이스에 맞춘 레이아웃으로 고정할 것인지 지정<br>
  /// [enableBackButton]로 배송지 피커의 뒤로 가기 버튼 노출 여부 지정<br>
  /// <br>
  /// EN: Select shipping address<br>
  /// [enableBackButton] and [mobileView] are web platform only parameters<br>
  /// Use [mobileView] to specify whether the picker is pinned to a layout adapted for mobile device<br>
  /// Use [enableBackButton] to show or hide the back button in the picker
  Future<int> selectShippingAddresses({
    bool? mobileView,
    bool? enableBackButton,
  }) async {
    try {
      if (!kIsWeb) {
        await AuthApi.instance.refreshToken();
      }
      final agt = await AuthApi.instance.agt();
      return _selectShippingAddresses(
        agt,
        enableBackButton: enableBackButton,
        mobileView: mobileView,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// KO: 배송지 가져오기<br>
  /// [addressId]에 배송지 ID 전달<br>
  /// [fromUpdatedAt]에 이전 페이지의 마지막 배송지 수정 시각 전달, `0` 전달 시 처음부터 조회<br>
  /// [pageSize]에 한 페이지에 포함할 배송지 수 전달(기본값: 10)<br>
  /// <br>
  /// EN: Retrieve shipping address<br>
  /// Pass the Shipping address ID to [addressId]<br>
  /// Pass the last shipping address modification on the previous page to [fromUpdatedAt], retrieve from beginning if passing `0'<br>
  /// Pass the number of shipping addresses displayed on a page to [pageSize](Default: 10)
  Future<UserShippingAddresses> shippingAddresses({
    int? addressId,
    DateTime? fromUpdatedAt,
    int? pageSize,
  }) async {
    Map<String, dynamic> params = {
      Constants.addressId: addressId,
      Constants.fromUpdatedAt: fromUpdatedAt == null
          ? null
          : fromUpdatedAt.millisecondsSinceEpoch / 1000,
      Constants.pageSize: pageSize,
    };
    params.removeWhere((k, v) => v == null);
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.get(Constants.v1ShippingAddressesPath,
          queryParameters: params);
      return UserShippingAddresses.fromJson(response.data);
    });
  }

  /// KO: 서비스 약관 동의 내역 확인하기<br>
  /// 서비스 약관 태그 목록은 [tags]에 전달<br>
  /// [result]에 조회 대상(`agreed_service_terms`: 사용자가 동의한 서비스 약관 목록 | `app_service_terms`: 앱에 사용 설정된 서비스 약관 목록, 기본값: `agreed_service_terms`) 전달<br>
  /// <br>
  /// EN: Retrieve consent details for service terms<br>
  /// Pass the tags of service terms to [tags]<br>
  /// Pass the result type (`agreed_service_terms`: List of service terms the user has agreed to | `app_service_terms`: List of service terms enabled for the app, Default: `agreed_service_terms`) to [result]
  Future<UserServiceTerms> serviceTerms({
    List<String>? tags,
    String? result,
  }) async {
    Map<String, dynamic> param = {
      Constants.tags: tags,
      Constants.result: result,
    };
    param.removeWhere((k, v) => v == null);
    return ApiFactory.handleApiError(() async {
      Response response =
          await _dio.get(Constants.v2ServiceTermsPath, queryParameters: param);
      return UserServiceTerms.fromJson(response.data);
    });
  }

  /// KO: 서비스 약관 동의 철회하기<br>
  /// 서비스 약관 태그 목록은 [tags]에 전달<br>
  /// <br>
  /// EN: Revoke consent for service terms<br>
  /// Pass the tags of service terms to [tags]
  Future<UserRevokedServiceTerms> revokeServiceTerms(
      {required List<String> tags}) async {
    Map<String, dynamic> param = {Constants.tags: tags.join(',')};
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.post(Constants.v2RevokeServiceTermsPath,
          queryParameters: param);
      return UserRevokedServiceTerms.fromJson(response.data);
    });
  }

  /// KO: 사용자 정보 저장하기
  /// <br>
  /// EN: Store user information
  Future<void> updateProfile(Map<String, String> properties) {
    return ApiFactory.handleApiError(() async {
      await _dio.post(Constants.v1UpdateProfilePath,
          data: {Constants.properties: jsonEncode(properties)});
    });
  }

  /// KO: 연결하기
  /// <br>
  /// EN: Manual signup
  Future<void> signup({Map<String, String>? properties}) {
    return ApiFactory.handleApiError(() async {
      await _dio.post(Constants.v1SignupPath,
          data: {Constants.properties: jsonEncode(properties)});
    });
  }

  /// KO: 동의 내역 확인하기
  /// <br>
  /// EN: Retrieve consent details
  Future<ScopeInfo> scopes({List<String>? scopes}) {
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.get(Constants.v2ScopesPath,
          queryParameters: {Constants.scopes: jsonEncode(scopes)});
      return ScopeInfo.fromJson(response.data);
    });
  }

  /// KO: 동의 철회하기<br>
  /// 동의 항목 ID 목록은 [scopes]에 전달<br>
  /// <br>
  /// EN: Revoke consent<br>
  /// Pass a list of the scope IDs to [scopes]
  Future<ScopeInfo> revokeScopes({required List<String> scopes}) {
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.post(Constants.v2RevokeScopesPath,
          data: {Constants.scopes: jsonEncode(scopes)});
      return ScopeInfo.fromJson(response.data);
    });
  }

  Future<int> _selectShippingAddresses(
    final String agt, {
    final bool? mobileView,
    final bool? enableBackButton,
  }) {
    if (kIsWeb) {
      return _selectShippingAddressesForWeb(
        agt,
        mobileView: mobileView,
        enableBackButton: enableBackButton,
      );
    }
    return _selectShippingAddressesForNative(agt);
  }

  Future<int> _selectShippingAddressesForWeb(
    final String agt, {
    final bool? mobileView,
    final bool? enableBackButton,
  }) async {
    final response =
        await _channel.invokeMethod(CommonConstants.selectShippingAddresses, {
      Constants.mobileView: mobileView,
      Constants.enableBackButton: enableBackButton,
      Constants.agt: agt,
      Constants.transId: generateRandomString(20),
    });
    final Map<String, dynamic> result = jsonDecode(response);

    if (result[Constants.status] == Constants.error) {
      throw KakaoAppsException.fromJson(result);
    }
    return result[Constants.addressId];
  }

  Future<int> _selectShippingAddressesForNative(final String agt) async {
    final continueUrl =
        Uri.https(KakaoSdk.hosts.apps, Constants.selectShippingAddressesPath, {
      Constants.appKey: KakaoSdk.appKey,
      Constants.ka: await KakaoSdk.kaHeader,
      Constants.returnUrl:
          '${KakaoSdk.customScheme}://${Constants.shippingAddressesScheme}',
      Constants.enableBackButton: 'false',
    }).toString();
    final url = Uri.https(KakaoSdk.hosts.apps, Constants.kpidtPath, {
      Constants.appKey: KakaoSdk.appKey,
      Constants.agt: agt,
      Constants.continueUrl: continueUrl,
    }).toString();

    final result = await _channel.invokeMethod(
        CommonConstants.selectShippingAddresses, {CommonConstants.url: url});
    final resultUri = Uri.parse(result);

    if (resultUri.queryParameters[Constants.status] == Constants.error) {
      throw KakaoAppsException.fromJson(resultUri.queryParameters);
    }
    return int.parse(resultUri.queryParameters[Constants.addressId]!);
  }
}
