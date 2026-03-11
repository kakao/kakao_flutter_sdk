import 'package:example/model/custom_data.dart';
import 'package:example/model/list_item.dart';
import 'package:example/util/log.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart';

const String _tag = "UserApi";

List<ListItem> createUserApis(CustomData customData) => <ListItem>[
  const Header(_tag),
  Api('isKakaoTalkInstalled()', (context) async {
    // 카카오톡 설치여부 조회
    final bool result = await isKakaoTalkInstalled();
    final msg = result ? '카카오톡으로 로그인 가능' : '카카오톡 미설치: 카카오계정으로 로그인 사용 권장';

    Log.i(_tag, msg);
  }),
  Api('loginWithKakaoTalk()', (context) async {
    // 카카오톡으로 로그인

    try {
      final OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      Log.i(_tag, '로그인 성공 ${token.accessToken}');
    } catch (e) {
      Log.e(_tag, '로그인 실패', e);
    }
  }),
  Api('loginWithKakaoAccount()', (context) async {
    // 카카오계정으로 로그인

    try {
      final OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      Log.i(_tag, '로그인 성공 ${token.accessToken}');
    } catch (e) {
      Log.e(_tag, '로그인 실패', e);
    }
  }),
  Api('loginWithKakao()', (context) async {
    try {
      final OAuthToken token = await UserApi.instance.loginWithKakao(context);
      Log.i(_tag, '로그인 성공 ${token.accessToken}');
    } catch (e) {
      Log.e(_tag, '로그인 실패', e);
    }
    // final OAuthToken token = await UserApi.instance.loginWithKakao(context);
    // return '로그인 성공 ${token.accessToken}';
  }),
  Api('loginWithKakaoAccount(prompts:login)', (context) async {
    // 카카오계정으로 로그인 - 재인증
    final OAuthToken token = await UserApi.instance.loginWithKakaoAccount(
      prompts: [Prompt.login],
    );
    return '로그인 성공 ${token.accessToken}';
  }),
  Api('Combination Login', (context) async {
    // 로그인 조합 예제

    final bool talkInstalled = await isKakaoTalkInstalled();

    // 카카오톡이 설치되어 있으면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (talkInstalled) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        Log.i(_tag, '카카오톡으로 로그인 성공 ${token.accessToken}');
      } catch (e) {
        Log.e(_tag, '카카오톡으로 로그인 실패', e);

        // 유저에 의해서 카카오톡으로 로그인이 취소된 경우 카카오계정으로 로그인 생략 (ex 뒤로가기)
        if (e is PlatformException && e.code == 'CANCELED') {
          return;
        }

        // 카카오톡에 로그인이 안되어있는 경우 카카오계정으로 로그인
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          Log.i(_tag, '카카오계정으로 로그인 성공 ${token.accessToken}');
        } catch (e) {
          Log.e(_tag, '카카오계정으로 로그인 실패', e);
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        Log.i(_tag, '카카오계정으로 로그인 성공 ${token.accessToken}');
      } catch (e) {
        Log.e(_tag, '카카오계정으로 로그인 실패', e);
      }
    }
  }),
  Api('Combination Login (Verbose)', (context) async {
    // 로그인 조합 예제 + 상세한 에러처리 콜백
    try {
      final bool talkInstalled = await isKakaoTalkInstalled();
      //   카카오톡이 설치되어 있으면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
      final OAuthToken token = talkInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();
      Log.i(_tag, '로그인 성공 ${token.accessToken}');
    } on KakaoClientException catch (e) {
      Log.e(_tag, '클라이언트 에러', e);
    } on KakaoAuthException catch (e) {
      if (e.error == AuthErrorCause.accessDenied) {
        Log.e(_tag, '취소됨 (동의 취소)', e);
      } else if (e.error == AuthErrorCause.misconfigured) {
        Log.e(
          _tag,
          '개발자사이트 앱 설정에 키 해시 또는 번들 ID를 등록하세요. 현재 값: ${KakaoSdk.platformInfo.origin}',
          e,
        );
      } else {
        Log.e(_tag, '기타 인증 에러', e);
      }
    } catch (e) {
      // 에러처리에 대한 개선사항이 필요하면 데브톡(https://devtalk.kakao.com)으로 문의해주세요.
      Log.e(_tag, '기타 에러 (네트워크 장애 등..)', e);
    }
  }),
  Api('me()', (context) async {
    // 사용자 정보 요청 (기본)

    try {
      User user = await UserApi.instance.me();
      Log.i(
        _tag,
        '사용자 정보 요청 성공'
        '\n회원번호: ${user.id}'
        '\n이메일: ${user.kakaoAccount?.email}'
        '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
        '\n프로필사진: ${user.kakaoAccount?.profile?.thumbnailImageUrl}',
      );
    } catch (e) {
      Log.e(_tag, '사용자 정보 요청 실패', e);
    }
  }),
  Api('me() - new scopes', (context) async {
    // 사용자 정보 요청 (추가 동의)

    // 사용자가 로그인 시 제3자 정보제공에 동의하지 않은 개인정보 항목 중 어떤 정보가 반드시 필요한 시나리오에 진입한다면
    // 다음과 같이 추가 동의를 받고 해당 정보를 획득할 수 있습니다.

    //  * 주의: 선택 동의항목은 사용자가 거부하더라도 서비스 이용에 지장이 없어야 합니다.

    // 추가 권한 요청 시나리오 예제

    User user;
    try {
      user = await UserApi.instance.me();
      Log.i(
        _tag,
        '사용자 정보 요청 성공'
        '\n회원번호: ${user.id}'
        '\n이메일: ${user.kakaoAccount?.email}'
        '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
        '\n프로필사진: ${user.kakaoAccount?.profile?.thumbnailImageUrl}',
      );
    } catch (e) {
      Log.e(_tag, '사용자 정보 요청 실패', e);
      return;
    }

    List<String> scopes = [];

    if (user.kakaoAccount?.emailNeedsAgreement == true) {
      scopes.add('account_email');
    }
    if (user.kakaoAccount?.birthdayNeedsAgreement == true) {
      scopes.add("birthday");
    }
    if (user.kakaoAccount?.birthyearNeedsAgreement == true) {
      scopes.add("birthyear");
    }
    if (user.kakaoAccount?.phoneNumberNeedsAgreement == true) {
      scopes.add("phone_number");
    }
    if (user.kakaoAccount?.profileNeedsAgreement == true) {
      scopes.add("profile");
    }
    if (user.kakaoAccount?.ageRangeNeedsAgreement == true) {
      scopes.add("age_range");
    }

    if (scopes.isNotEmpty) {
      Log.d(_tag, '사용자에게 추가 동의를 받아야 합니다.');

      OAuthToken token;
      try {
        token = await UserApi.instance.loginWithNewScopes(scopes);
        Log.i(_tag, 'allowed scopes: ${token.scopes}');
      } catch (e) {
        Log.e(_tag, "사용자 추가 동의 실패", e);
        return;
      }

      // 사용자 정보 재요청
      try {
        User user = await UserApi.instance.me();
        Log.i(
          _tag,
          '사용자 정보 요청 성공'
          '\n회원번호: ${user.id}'
          '\n이메일: ${user.kakaoAccount?.email}'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
          '\n프로필사진: ${user.kakaoAccount?.profile?.thumbnailImageUrl}',
        );
      } catch (e) {
        Log.e(_tag, '사용자 정보 요청 실패', e);
      }
    }
  }),
  Api('signup()', (context) async {
    try {
      await UserApi.instance.signup();
      Log.i(_tag, 'signup 성공');
    } catch (e) {
      Log.e(_tag, 'signup 실패', e);
    }
  }),
  Api('accessTokenInfo()', (context) async {
    // 토큰 정보 보기

    try {
      final AccessTokenInfo tokenInfo = await UserApi.instance
          .accessTokenInfo();
      Log.i(
        _tag,
        '토큰 정보 보기 성공\n회원정보: ${tokenInfo.id}\n만료시간: ${tokenInfo.expiresIn} 초',
      );
    } catch (e) {
      Log.e(_tag, '동의 철회 실패', e);
    }
  }),
  Api('updateProfile()', (context) async {
    // 사용자 정보 저장

    try {
      // 변경할 내용
      final properties = <String, String>{'custom_key': "${DateTime.now()}"};
      await UserApi.instance.updateProfile(properties);
      Log.i(_tag, '사용자 정보 저장 성공');
    } catch (e) {
      Log.e(_tag, '사용자 정보 저장 실패', e);
    }
  }),
  Api('selectShippingAddress()', (context) async {
    // 배송지 피커 호출
    try {
      final addressId = await UserApi.instance.selectShippingAddress();
      Log.i(_tag, '배송지 선택 성공 $addressId');
    } catch (e) {
      Log.e(_tag, '배송지 선택 실패 $e');
    }
  }),
  Api('shippingAddresses()', (context) async {
    // 배송지 조회 (추가 동의)

    UserShippingAddresses userShippingAddress;
    try {
      userShippingAddress = await UserApi.instance.shippingAddresses();
    } catch (e) {
      Log.e(_tag, '배송지 조회 실패', e);
      return;
    }

    if (userShippingAddress.shippingAddresses != null) {
      Log.i(
        _tag,
        '배송지 조회 성공\n회원번호: ${userShippingAddress.userId}\n배송지: \n${userShippingAddress.shippingAddresses?.join('\n')}',
      );
    } else if (userShippingAddress.needsAgreement == false) {
      Log.e(_tag, '사용자 계정에 배송지 없음. 꼭 필요하다면 동의항목 설정에서 수집 기능을 활성화 해보세요.');
    } else if (userShippingAddress.needsAgreement == true) {
      Log.d(_tag, '사용자에게 배송지 제공 동의를 받아야 합니다.');

      final scopes = <String>['shipping_address'];

      // 사용자에게 배송지 제공 동의 요청
      OAuthToken token;
      try {
        token = await UserApi.instance.loginWithNewScopes(scopes);
        Log.d(_tag, 'allowed scopes: ${token.scopes}');
      } catch (e) {
        Log.e(_tag, '배송지 제공 동의 실패', e);
      }

      try {
        UserShippingAddresses userShippingAddresses = await UserApi.instance
            .shippingAddresses();
        Log.i(
          _tag,
          '배송지 조회 성공\n회원번호: ${userShippingAddresses.userId}\n${userShippingAddresses.shippingAddresses?.join('\n')}',
        );
      } catch (e) {
        Log.e(_tag, '배송지 조회 실패', e);
      }
    }
  }),
  Api('serviceTerms()', (context) async {
    // 서비스 약관 동의 내역 조회

    try {
      final UserServiceTerms userServiceTerms = await UserApi.instance
          .serviceTerms(
            tags: customData.serviceTerms,
            result: 'app_service_terms',
          );
      Log.i(
        _tag,
        '서비스 약관 동의 내역 조회 성공\n회원정보: ${userServiceTerms.id}\n동의한 약관: \n${userServiceTerms.serviceTerms?.join('\n')}',
      );
    } catch (e) {
      Log.e(_tag, '서비스 약관 동의 내역 조회 실패', e);
    }
  }),
  Api('revokeServiceTerms()', (context) async {
    // 약관 철회

    try {
      UserRevokedServiceTerms userRevokedServiceTerms = await UserApi.instance
          .revokeServiceTerms(customData.serviceTerms);
      Log.i(
        _tag,
        '서비스 약관 동의 철회 성공\n회원정보: ${userRevokedServiceTerms.id}\n철회한 약관: \n${userRevokedServiceTerms.revokedServiceTerms?.join('\n')}',
      );
    } catch (e) {
      Log.e(_tag, '서비스 약관 동의 철회 실패', e);
    }
  }),
  Api('scopes()', (context) async {
    // 동의 항목 동의 내역 조회

    try {
      final ScopeInfo scopeInfo = await UserApi.instance.scopes(
        scopes: customData.scopes,
      );
      Log.i(_tag, '동의 정보 조회 성공\n현재 가지고 있는 동의 항목 ${scopeInfo.scopes}');
    } catch (e) {
      Log.e(_tag, '동의 정보 조회 실패', e);
    }
  }),
  Api('revokeScopes()', (context) async {
    try {
      final ScopeInfo scopeInfo = await UserApi.instance.revokeScopes(
        customData.scopes,
      );
      Log.i(_tag, '동의 철회 성공\n현재 가지고 있는 동의 항목 ${scopeInfo.scopes}');
    } catch (e) {
      Log.e(_tag, '동의 철회 실패', e);
    }
  }),
  Api('logout()', (context) async {
    // 로그아웃

    try {
      await UserApi.instance.logout();
      Log.i(_tag, '로그아웃 성공. SDK에서 토큰 삭제 됨');
    } catch (e) {
      Log.e(_tag, '로그아웃 실패. SDK에서 토큰 삭제 됨', e);
    }
  }),
  Api('unlink()', (context) async {
    // 연결 끊기

    try {
      await UserApi.instance.unlink();
      Log.i(_tag, '연결 끊기 성공. SDK에서 토큰 삭제 됨');
    } catch (e) {
      Log.e(_tag, '연결 끊기 실패', e);
    }
  }),
];
