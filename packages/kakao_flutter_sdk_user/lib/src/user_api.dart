import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import 'package:kakao_flutter_sdk_user/src/constants.dart';

import 'model/access_token_info.dart';
import 'model/scope_info.dart';
import 'model/user.dart';
import 'model/user_id_response.dart';
import 'model/user_service_terms.dart';
import 'model/user_shipping_addresses.dart';

/// 사용자관리 API 호출을 담당하는 클라이언트
class UserApi {
  UserApi(this._dio);

  final Dio _dio;

  /// 간편한 API 호출을 위해 기본 제공되는 singleton 객체
  static final UserApi instance = UserApi(AuthApiFactory.authApi);

  /// 카카오톡으로 로그인
  /// 카카오톡에 연결된 카카오계정으로 사용자를 인증하고 [OAuthToken] 발급
  /// 발급된 토큰은 [TokenManagerProvider]에 지정된 토큰 저장소에 자동으로 저장됨
  /// ID 토큰 재생 공격 방지를 위한 검증 값은 [nonce]로 전달. 임의의 문자열, ID 토큰 검증 시 사용
  Future<OAuthToken> loginWithKakaoTalk({
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
    String? nonce,
  }) async {
    var codeVerifier = AuthCodeClient.codeVerifier();
    final authCode = await AuthCodeClient.instance.requestWithTalk(
      channelPublicId: channelPublicIds,
      serviceTerms: serviceTerms,
      codeVerifier: codeVerifier,
      nonce: nonce,
    );
    final token = await AuthApi.instance
        .issueAccessToken(authCode: authCode, codeVerifier: codeVerifier);
    await TokenManagerProvider.instance.manager.setToken(token);
    return token;
  }

  /// 앱투앱(App-to-App) 방식 카카오톡 인증 로그인
  ///
  /// 카카오톡을 실행하고, 카카오톡에 연결된 카카오계정으로 사용자 인증 후 동의 및 전자서명을 거쳐 [CertTokenInfo] 반환
  ///
  /// 동의 화면 요청 시 추가 상호작용을 요청하고자 할 때는 [prompts] 전달, 사용할 수 있는 옵션의 종류는 [Prompt] 참고
  /// ID 토큰 재생 공격 방지를 위한 검증 값은 [nonce] 전달. 임의의 문자열, ID 토큰 검증 시 사용
  /// 전자서명 원문은 [state]로 전달
  Future<CertTokenInfo> certLoginWithKakaoTalk({
    List<Prompt>? prompts,
    required String state,
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
    String? nonce,
  }) async {
    var codeVerifier = AuthCodeClient.codeVerifier();
    final authCode = await AuthCodeClient.instance.requestWithTalk(
      prompts: prompts,
      state: state,
      channelPublicId: channelPublicIds,
      serviceTerms: serviceTerms,
      codeVerifier: codeVerifier,
      nonce: nonce,
    );
    final certTokenInfo = await AuthApi.instance.issueAccessTokenWithCert(
        authCode: authCode, codeVerifier: codeVerifier);
    await TokenManagerProvider.instance.manager.setToken(certTokenInfo.token);
    return certTokenInfo;
  }

  /// 카카오계정으로 로그인. 기본 웹 브라우저에 있는 카카오계정 cookie 로 사용자를 인증하고 [OAuthToken] 발급
  ///
  /// 발급된 토큰은 [TokenManagerProvider]에 지정된 토큰 저장소에 자동으로 저장됨
  ///
  /// 동의 화면 요청 시 추가 상호작용을 요청하고자 할 때는 [prompts]를 전달
  /// 카카오계정 로그인 페이지의 ID에 자동 입력할 이메일 또는 전화번호(+82 00-0000-0000 형식)는 [loginHint]에 전달
  /// ID 토큰 재생 공격 방지를 위한 검증 값은 [nonce]로 전달. 임의의 문자열, ID 토큰 검증 시 사용
  Future<OAuthToken> loginWithKakaoAccount({
    List<Prompt>? prompts,
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
    String? loginHint,
    String? nonce,
  }) async {
    String codeVerifier = AuthCodeClient.codeVerifier();
    final authCode = await AuthCodeClient.instance.request(
      prompts: prompts,
      channelPublicIds: channelPublicIds,
      serviceTerms: serviceTerms,
      codeVerifier: codeVerifier,
      loginHint: loginHint,
      nonce: nonce,
    );
    final token = await AuthApi.instance
        .issueAccessToken(authCode: authCode, codeVerifier: codeVerifier);
    await TokenManagerProvider.instance.manager.setToken(token);
    return token;
  }

  /// 채널 메시지 방식 카카오톡 인증 로그인
  ///
  /// 기본 브라우저의 카카오계정 쿠키(cookie)로 사용자 인증 후, 카카오계정에 연결된 카카오톡으로 카카오톡 인증 로그인을 요청하는 채널 메시지 발송
  /// 카카오톡의 채널 메시지를 통해 동의 및 전자서명을 거쳐 [CertTokenInfo] 반환
  ///
  /// 동의 화면 요청 시 추가 상호작용을 요청하고자 할 때는 [prompts] 전달, 사용할 수 있는 옵션의 종류는 [Prompt] 참고
  /// 카카오계정 로그인 페이지의 ID에 자동 입력할 이메일 또는 전화번호(+82 00-0000-0000 형식)는 [loginHint]에 전달
  /// ID 토큰 재생 공격 방지를 위한 검증 값은 [nonce]로 전달. 임의의 문자열, ID 토큰 검증 시 사용
  /// 전자서명 원문은 [state]로 전달
  Future<CertTokenInfo> certLoginWithKakaoAccount({
    List<Prompt>? prompts,
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
    String? loginHint,
    required String state,
    String? nonce,
  }) async {
    var codeVerifier = AuthCodeClient.codeVerifier();
    final authCode = await AuthCodeClient.instance.request(
      prompts: prompts,
      state: state,
      channelPublicIds: channelPublicIds,
      serviceTerms: serviceTerms,
      codeVerifier: codeVerifier,
      loginHint: loginHint,
      nonce: nonce,
    );
    final certTokenInfo = await AuthApi.instance.issueAccessTokenWithCert(
        authCode: authCode, codeVerifier: codeVerifier);
    await TokenManagerProvider.instance.manager.setToken(certTokenInfo.token);
    return certTokenInfo;
  }

  /// 사용자가 아직 동의하지 않은 개인정보 및 접근권한 동의 항목에 대하여 동의를 요청하는 동의 화면을 출력하고, 사용자 동의 시 동의항목이 업데이트 된 [OAuthToken] 발급
  ///
  /// 발급된 토큰은 [TokenManagerProvider]에 지정된 토큰 저장소에 자동으로 저장됨
  ///
  /// [scopes]로 추가로 동의 받고자 하는 동의 항목 ID 목록을 전달함
  /// 카카오 디벨로퍼스 동의 항목 설정 화면에서 확인 가능
  /// ID 토큰 재생 공격 방지를 위한 검증 값은 [nonce]로 전달. 임의의 문자열, ID 토큰 검증 시 사용
  Future<OAuthToken> loginWithNewScopes(List<String> scopes,
      {String? nonce}) async {
    String codeVerifier = AuthCodeClient.codeVerifier();
    final authCode = await AuthCodeClient.instance.requestWithAgt(
        scopes: scopes, codeVerifier: codeVerifier, nonce: nonce);
    final token = await AuthApi.instance
        .issueAccessToken(authCode: authCode, codeVerifier: codeVerifier);
    await TokenManagerProvider.instance.manager.setToken(token);
    return token;
  }

  /// 사용자 정보 요청
  Future<User> me({bool secureResource = true}) async {
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.get(Constants.v2MePath,
          queryParameters: {Constants.secureResource: secureResource});
      return User.fromJson(response.data);
    });
  }

  /// 현재 토큰을 강제로 만료시키고 로그아웃
  ///
  /// API 호출 결과와 관계 없이 [TokenManagerProvider]에 지정된 저장소에서 토큰을 자동으로 삭제함
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

  /// 연결 끊기. 카카오 로그인을 통한 사용자와 서비스 간의 연결 관계를 해제하고 사용자의 정보 제공 및 카카오 플랫폼 사용을 중단
  ///
  /// API 호출에 성공하면 [TokenManagerProvider]에 지정된 저장소에서 토큰을 자동으로 삭제함
  Future<UserIdResponse> unlink() async {
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.post(Constants.v1UnlinkPath);
      await TokenManagerProvider.instance.manager.clear();
      return UserIdResponse.fromJson(response.data);
    });
  }

  /// 현재 로그인한 사용자의 엑세스 토큰 정보 보기
  ///
  /// [me] 에서 제공되는 다양한 사용자 정보 없이 가볍게 토큰의 유효성을 체크하는 용도로 추천
  /// 액세스 토큰이 만료된 경우 자동으로 갱신된 새로운 액세스 토큰 정보 반환
  Future<AccessTokenInfo> accessTokenInfo() async {
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.get(Constants.v1AccessTokenInfoPath);
      return AccessTokenInfo.fromJson(response.data);
    });
  }

  /// 사용자의 배송지 정보 획득
  Future<UserShippingAddresses> shippingAddresses({
    int? fromUpdateAt,
    int? pageSize,
  }) async {
    Map<String, dynamic> params = {
      Constants.fromUpdatedAt: fromUpdateAt,
      Constants.pageSize: pageSize,
    };
    params.removeWhere((k, v) => v == null);
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.get(Constants.v1ShippingAddressesPath,
          queryParameters: params);
      return UserShippingAddresses.fromJson(response.data);
    });
  }

  /// 사용자가 카카오 간편가입을 통해 동의한 서비스 약관 내역 반환
  Future<UserServiceTerms> serviceTerms({String? extra}) async {
    Map<String, dynamic> param = {Constants.extra: extra};
    param.removeWhere((k, v) => v == null);
    return ApiFactory.handleApiError(() async {
      Response response =
          await _dio.get(Constants.v1ServiceTermsPath, queryParameters: param);
      return UserServiceTerms.fromJson(response.data);
    });
  }

  /// User 클래스에서 제공되고 있는 사용자의 부가정보를 신규저장 및 수정
  ///
  /// 저장 가능한 키 이름은 카카오 디벨로퍼스 > 카카오 로그인 > 사용자 프로퍼티 메뉴에서 확인
  /// 앱 연결 시 기본 저장되는 nickname, profile_image, thumbnail_image 값도 덮어쓰기 가능하며 새로운 컬럼을 추가하면 해당 키 이름으로 정보 저장 가능
  Future<void> updateProfile(Map<String, String> properties) {
    return ApiFactory.handleApiError(() async {
      await _dio.post(Constants.v1UpdateProfilePath,
          data: {Constants.properties: jsonEncode(properties)});
    });
  }

  /// 앱 연결 상태가 **PREREGISTER** 상태의 사용자에 대하여 앱 연결 요청
  /// **자동연결** 설정을 비활성화한 앱에서 사용
  Future<void> signup({Map<String, String>? properties}) {
    return ApiFactory.handleApiError(() async {
      await _dio.post(Constants.v1SignupPath,
          data: {Constants.properties: jsonEncode(properties)});
    });
  }

  /// 사용자 동의 항목의 상세 정보 목록 반환
  Future<ScopeInfo> scopes({List<String>? scopes}) {
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.get(Constants.v2ScopesPath,
          queryParameters: {Constants.scopes: jsonEncode(scopes)});
      return ScopeInfo.fromJson(response.data);
    });
  }

  /// 사용자의 특정 동의 항목에 대한 동의를 철회하고, 남은 사용자 동의 항목의 상세 정보 목록 반환
  ///
  /// [scopes]로 동의를 철회할 동의 항목 ID 목록 전달
  Future<ScopeInfo> revokeScopes({required List<String> scopes}) {
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.post(Constants.v2RevokeScopesPath,
          data: {Constants.scopes: jsonEncode(scopes)});
      return ScopeInfo.fromJson(response.data);
    });
  }
}
