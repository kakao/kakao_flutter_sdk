import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';

import 'component/login_bridge_bottom_sheet.dart';
import 'constants.dart';
import 'model/access_token_info.dart';
import 'model/account_login_params.dart';
import 'model/login_ui_mode.dart';
import 'model/scope_info.dart';
import 'model/user.dart';
import 'model/user_id_response.dart';
import 'model/user_response.dart';
import 'model/user_revoked_service_terms.dart';
import 'model/user_service_terms.dart';
import 'model/user_shipping_addresses.dart';
import 'user_platform.dart';

/// KO: 카카오 로그인 API 클래스
/// <br>
/// EN: Class for the Kakao Login APIs
class UserApi {
  /// @nodoc
  UserApi({
    KakaoHttpClient? client,
    AuthPlatform? authPlatform,
    UserPlatform? userPlatform,
    AuthCodeClient? authCodeClient,
    AuthApi? authApi,
  }) : _client = client ?? KakaoAuthHttpClientFactory.authApi,
       _userPlatform = userPlatform ?? UserPlatform.instance,
       _authCodeClient = authCodeClient ?? AuthCodeClient.instance,
       _authApi = authApi ?? AuthApi.instance;

  final KakaoHttpClient _client;
  final UserPlatform _userPlatform;
  final AuthCodeClient _authCodeClient;
  final AuthApi _authApi;

  /// @nodoc
  static final UserApi instance = UserApi();

  /// KO: 카카오톡으로 로그인<br>
  /// [channelPublicIds]에 카카오톡 채널 프로필 ID 전달<br>
  /// [serviceTerms] 서비스 약관 목록 전달<br>
  /// ID 토큰 재생 공격 방지를 위한 검증 값, 임의의 문자열은 [nonce]에 전달<br>
  /// <br>
  /// EN: Login with Kakao Talk<br>
  /// Pass list of Kakao Talk Channel IDs to [channelPublicIds]<br>
  /// Pass list of service terms to [serviceTerms]
  Future<OAuthToken> loginWithKakaoTalk({
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
    String? nonce,
  }) async {
    if (kIsWeb) {
      throw KakaoClientException(
        ClientErrorCause.notSupported,
        'loginWithKakaoTalk() is not supported on web platforms.',
      );
    }

    SdkLog.d(
      '[UserApi.loginWithKakaoTalk] started | channelCount=${channelPublicIds?.length ?? 0} serviceTermsCount=${serviceTerms?.length ?? 0} nonceProvided=${nonce != null}',
    );
    final codeVerifier = generateRandomString(20);

    final authCode = await _authCodeClient.authorizeWithTalk(
      redirectUri: KakaoSdk.redirectUri,
      nonce: nonce,
      codeVerifier: codeVerifier,
      channelPublicId: channelPublicIds,
      serviceTerms: serviceTerms,
    );

    final token = await _authApi.issueAccessToken(
      authCode: authCode,
      redirectUri: KakaoSdk.redirectUri,
      codeVerifier: codeVerifier,
    );
    await TokenManagerProvider.instance.manager.setToken(token);
    SdkLog.i(
      '[UserApi.loginWithKakaoTalk] completed | hasRefreshToken=${token.refreshToken != null}',
    );
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
  /// Pass List of Kakao Talk Channel IDs to [channelPublicIds]<br>
  /// Pass list of service terms to [serviceTerms]<br>
  /// Pass a value to fill in the ID field of the Kakao Account login page to [loginHint]<br>
  /// Pass a random string to prevent replay attacks to [nonce]
  Future<OAuthToken> loginWithKakaoAccount({
    List<Prompt>? prompts,
    String? loginHint,
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
    String? nonce,
  }) async {
    if (kIsWeb) {
      throw KakaoClientException(
        ClientErrorCause.notSupported,
        'loginWithKakaoAccount() is not supported on web platforms.',
      );
    }

    SdkLog.d(
      '[UserApi.loginWithKakaoAccount] started | prompts=${prompts?.map((e) => e.name).join(',')} channelCount=${channelPublicIds?.length ?? 0} serviceTermsCount=${serviceTerms?.length ?? 0} loginHintProvided=${loginHint != null} nonceProvided=${nonce != null}',
    );
    final codeVerifier = generateRandomString(20);
    final redirectUri = KakaoSdk.redirectUri;

    final authCode = await _authCodeClient.authorize(
      redirectUri: redirectUri,
      prompts: prompts,
      loginHint: loginHint,
      nonce: nonce,
      channelPublicIds: channelPublicIds,
      serviceTerms: serviceTerms,
      codeVerifier: codeVerifier,
    );

    final token = await _authApi.issueAccessToken(
      authCode: authCode,
      redirectUri: redirectUri,
      codeVerifier: codeVerifier,
    );
    await TokenManagerProvider.instance.manager.setToken(token);
    SdkLog.i(
      '[UserApi.loginWithKakaoAccount] completed | hasRefreshToken=${token.refreshToken != null}',
    );
    return token;
  }

  /// KO: 카카오톡으로 로그인과 카카오계정으로 로그인 중 하나를 선택할 수 있는 화면 제공<br>
  /// [uiMode]에 로그인 선택 화면 모드 전달<br>
  /// [accountParams]에 카카오계정으로 로그인 기능을 위한 설정 전달<br>
  /// [channelPublicIds]에 카카오톡 채널 프로필 ID 전달<br>
  /// [serviceTerms] 서비스 약관 목록 전달<br>
  /// ID 토큰 재생 공격 방지를 위한 검증 값, 임의의 문자열은 [nonce]에 전달<br>
  /// <br>
  /// EN: Provides a screen where users can choose between logging in with Kakao Talk or Kakao Account.<br>
  /// Pass the login selection screen mode to [uiMode]<br>
  /// Pass the settings for the Kakao Account login feature to [accountParams]<br>
  /// Pass list of Kakao Talk Channel IDs to [channelPublicIds]<br>
  /// Pass list of service terms to [serviceTerms]<br>
  /// Pass a random string to prevent replay attacks to [nonce]
  Future<OAuthToken> loginWithKakao(
    BuildContext context, {
    LoginUiMode uiMode = LoginUiMode.auto,
    AccountLoginParams? accountParams,
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
    String? nonce,
  }) async {
    if (kIsWeb) {
      throw KakaoClientException(
        ClientErrorCause.notSupported,
        'loginWithKakao() is not supported on web platform.',
      );
    }

    SdkLog.d('[UserApi.loginWithKakao] started | uiMode=${uiMode.name}');
    final loginMethod = await showModalBottomSheet(
      context: context,
      constraints: BoxConstraints.fromViewConstraints(
        const ViewConstraints(maxWidth: double.infinity, minHeight: 246),
      ),
      isScrollControlled: true,
      builder: (_) => LoginBridgeBottomSheet(
        uiMode: uiMode,
        onTalkLoginPressed: () async => Navigator.of(context).pop('talk'),
        onAccountLoginPressed: () async => Navigator.of(context).pop('account'),
      ),
    );

    if (loginMethod == 'talk') {
      SdkLog.i('[UserApi.loginWithKakao] selection | method=talk');
      return await loginWithKakaoTalk(
        channelPublicIds: channelPublicIds,
        serviceTerms: serviceTerms,
        nonce: nonce,
      );
    } else if (loginMethod == 'account') {
      SdkLog.i('[UserApi.loginWithKakao] selection | method=account');
      return await loginWithKakaoAccount(
        prompts: accountParams?.prompts,
        channelPublicIds: channelPublicIds,
        serviceTerms: serviceTerms,
        loginHint: accountParams?.loginHint,
        nonce: nonce,
      );
    }

    SdkLog.w('[UserApi.loginWithKakao] cancelled | reason=chooser_dismissed');
    throw KakaoClientException(ClientErrorCause.cancelled, 'User Cancelled');
  }

  /// KO: 동의항목 추가 동의 요청<br>
  /// 동의 항목 ID 목록은 [scopes]에 전달<br>
  /// <br>
  /// EN: Request additional consent<br>
  /// Pass a list of the scope IDs to [scopes]
  Future<OAuthToken> loginWithNewScopes(
    List<String> scopes, {
    String? nonce,
  }) async {
    if (kIsWeb) {
      throw KakaoClientException(
        ClientErrorCause.notSupported,
        'loginWithNewScopes() is not supported on web platform.',
      );
    }

    SdkLog.d(
      '[UserApi.loginWithNewScopes] started | scopeCount=${scopes.length} nonceProvided=${nonce != null}',
    );
    final redirectUri = KakaoSdk.redirectUri;
    final codeVerifier = generateRandomString(20);

    final authCode = await _authCodeClient.authorizeWithNewScopes(
      redirectUri: redirectUri,
      scopes: scopes,
      nonce: nonce,
      codeVerifier: codeVerifier,
    );
    final token = await _authApi.issueAccessToken(
      authCode: authCode,
      redirectUri: redirectUri,
      codeVerifier: codeVerifier,
    );
    await TokenManagerProvider.instance.manager.setToken(token);
    SdkLog.i(
      '[UserApi.loginWithNewScopes] completed | hasRefreshToken=${token.refreshToken != null}',
    );
    return token;
  }

  /// KO: 사용자 정보 조회
  /// <br>
  /// EN: Retrieve user information
  Future<User> me({
    List<String>? properties,
    bool secureResource = true,
  }) async {
    SdkLog.d(
      '[UserApi.me] started | propertiesCount=${properties?.length ?? 0} secureResource=$secureResource',
    );
    final params = <String, String>{
      Constants.propertyKeys: ?(properties != null
          ? jsonEncode(properties)
          : null),
      Constants.secureResource: secureResource.toString(),
    };

    final response = await _client.get(
      Constants.v2MePath,
      queryParameters: params,
    );
    final userResponse = UserResponse.fromJson(response.data);
    SdkLog.i('[UserApi.me] completed | id=${userResponse.id}');
    return userResponse.toUser();
  }

  /// KO: 로그아웃
  /// <br>
  /// EN: Logout
  Future<UserIdResponse> logout() async {
    SdkLog.d('[UserApi.logout] started');
    try {
      final response = await _client.post(Constants.v1LogoutPath);
      final result = UserIdResponse.fromJson(response.data);
      SdkLog.i('[UserApi.logout] completed | userId=${result.id}');
      return result;
    } finally {
      await TokenManagerProvider.instance.manager.clear();
      SdkLog.i('[UserApi.logout] local_state_cleared');
    }
  }

  /// KO: 연결 해제
  /// <br>
  /// EN: Unlink
  Future<UserIdResponse> unlink() async {
    SdkLog.d('[UserApi.unlink] started');
    final response = await _client.post(Constants.v1UnlinkPath);
    await TokenManagerProvider.instance.manager.clear();
    final result = UserIdResponse.fromJson(response.data);
    SdkLog.i('[UserApi.unlink] completed | userId=${result.id}');
    return result;
  }

  /// KO: 액세스 토큰 정보 조회
  /// <br>
  /// EN: Access token information
  Future<AccessTokenInfo> accessTokenInfo() async {
    SdkLog.d('[UserApi.accessTokenInfo] started');
    final response = await _client.get(Constants.v1AccessTokenInfoPath);
    final info = AccessTokenInfo.fromJson(response.data);
    SdkLog.i(
      '[UserApi.accessTokenInfo] completed | id=${info.id} expiresIn=${info.expiresIn}',
    );
    return info;
  }

  /// KO: 배송지 선택<br>
  /// [enableBackButton]과 [mobileView]는 웹 플랫폼 전용 파라미터<br>
  /// [mobileView]로 배송지 피커를 모바일 디바이스에 맞춘 레이아웃으로 고정할 것인지 지정<br>
  /// [enableBackButton]로 배송지 피커의 뒤로 가기 버튼 노출 여부 지정<br>
  /// <br>
  /// EN: Select shipping address<br>
  /// [enableBackButton] and [mobileView] are web platform only parameters<br>
  /// Use [mobileView] to specify whether the picker is pinned to a layout adapted for mobile device<br>
  /// Use [enableBackButton] to show or hide the back button in the picker
  Future<int> selectShippingAddress({
    bool? mobileView,
    bool? enableBackButton,
  }) {
    SdkLog.d(
      '[UserApi.selectShippingAddress] started | mobileView=${mobileView ?? false} enableBackButton=${enableBackButton ?? false}',
    );
    return _userPlatform.selectShippingAddress(
      enableBackButton: enableBackButton,
      mobileView: mobileView,
    );
  }

  /// KO: 배송지 조회<br>
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
    SdkLog.d(
      '[UserApi.shippingAddresses] started | addressId=$addressId fromUpdatedAt=${fromUpdatedAt?.toIso8601String()} pageSize=$pageSize',
    );
    final params = <String, Object>{
      Constants.addressId: ?addressId,
      Constants.fromUpdatedAt: ?(fromUpdatedAt != null
          ? fromUpdatedAt.millisecondsSinceEpoch / 1000
          : null),
      Constants.pageSize: ?pageSize,
    };
    final response = await _client.get(
      Constants.v1ShippingAddressesPath,
      queryParameters: params,
    );
    final result = UserShippingAddresses.fromJson(response.data);
    SdkLog.i(
      '[UserApi.shippingAddresses] completed | count=${result.shippingAddresses?.length ?? 0}',
    );
    return result;
  }

  /// KO: 서비스 약관 동의 내역 조회<br>
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
    SdkLog.d(
      '[UserApi.serviceTerms] started | tagsCount=${tags?.length ?? 0} result=$result',
    );
    final params = <String, String>{
      Constants.tags: ?tags?.join(','),
      Constants.result: ?result,
    };

    final response = await _client.get(
      Constants.v2ServiceTermsPath,
      queryParameters: params,
    );
    final terms = UserServiceTerms.fromJson(response.data);
    SdkLog.i(
      '[UserApi.serviceTerms] completed | count=${terms.serviceTerms?.length ?? 0}',
    );
    return terms;
  }

  /// KO: 서비스 약관 동의 철회<br>
  /// 서비스 약관 태그 목록은 [tags]에 전달<br>
  /// <br>
  /// EN: Revoke consent for service terms<br>
  /// Pass the tags of service terms to [tags]
  Future<UserRevokedServiceTerms> revokeServiceTerms(List<String> tags) async {
    SdkLog.d('[UserApi.revokeServiceTerms] started | tagsCount=${tags.length}');
    final response = await _client.post(
      Constants.v2RevokeServiceTermsPath,
      data: {Constants.tags: tags.join(',')},
    );
    final result = UserRevokedServiceTerms.fromJson(response.data);
    SdkLog.i(
      '[UserApi.revokeServiceTerms] completed | count=${result.revokedServiceTerms?.length ?? 0}',
    );
    return result;
  }

  /// KO: 사용자 프로퍼티 저장
  /// <br>
  /// EN: Store user properties
  Future<void> updateProfile(Map<String, String> properties) {
    SdkLog.d(
      '[UserApi.updateProfile] started | propertiesCount=${properties.length}',
    );
    return _client.post(
      Constants.v1UpdateProfilePath,
      data: {Constants.properties: properties.toJson()},
    );
  }

  /// KO: 수동 연결
  /// <br>
  /// EN: Manual signup
  Future<void> signup({Map<String, String>? properties}) {
    SdkLog.d(
      '[UserApi.signup] started | propertiesCount=${properties?.length ?? 0}',
    );
    final data = properties != null
        ? {Constants.properties: properties.toJson()}
        : null;
    return _client.post(Constants.v1SignupPath, data: data);
  }

  /// KO: 동의 내역 조회
  /// <br>
  /// EN: Retrieve consent details
  Future<ScopeInfo> scopes({List<String>? scopes}) async {
    SdkLog.d(
      '[UserApi.scopes] started | requestedScopeCount=${scopes?.length ?? 0}',
    );
    final params = <String, String>{
      Constants.scopes: ?(scopes != null ? jsonEncode(scopes) : null),
    };
    final response = await _client.get(
      Constants.v2ScopesPath,
      queryParameters: params,
    );
    final info = ScopeInfo.fromJson(response.data);
    SdkLog.i(
      '[UserApi.scopes] completed | scopeCount=${info.scopes?.length ?? 0}',
    );
    return info;
  }

  /// KO: 동의 철회<br>
  /// 동의 항목 ID 목록은 [scopes]에 전달<br>
  /// <br>
  /// EN: Revoke consent<br>
  /// Pass a list of the scope IDs to [scopes]
  Future<ScopeInfo> revokeScopes(List<String> scopes) async {
    SdkLog.d('[UserApi.revokeScopes] started | scopeCount=${scopes.length}');
    final response = await _client.post(
      Constants.v2RevokeScopesPath,
      data: {Constants.scopes: jsonEncode(scopes)},
    );
    final info = ScopeInfo.fromJson(response.data);
    SdkLog.i(
      '[UserApi.revokeScopes] completed | remainingScopeCount=${info.scopes?.length ?? 0}',
    );
    return info;
  }
}
