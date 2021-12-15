import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_example/api_item.dart';
import 'package:kakao_flutter_sdk_example/debug_page.dart';
import 'package:kakao_flutter_sdk_example/log.dart';
import 'package:kakao_flutter_sdk_example/server_phase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'server_phase.dart';

const String tag = "KakaoSdkSample";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeSdk();

  runApp(MyApp());
}

Future _initializeSdk() async {
  KakaoPhase phase = await _getKakaoPhase();
  KakaoSdk.init(
    nativeAppKey: PhasedAppKey(phase).getAppKey(),
    serviceHosts: PhasedServerHosts(phase),
    loggingEnabled: true,
  );
}

Future<KakaoPhase> _getKakaoPhase() async {
  var prefs = await SharedPreferences.getInstance();
  var prevPhase = prefs.getString('KakaoPhase');
  print('$prevPhase');
  KakaoPhase phase;
  if (prevPhase == null) {
    phase = KakaoPhase.PRODUCTION;
  } else {
    if (prevPhase == "DEV") {
      phase = KakaoPhase.DEV;
    } else if (prevPhase == "SANDBOX") {
      phase = KakaoPhase.SANDBOX;
    } else if (prevPhase == "CBT") {
      phase = KakaoPhase.CBT;
    } else {
      phase = KakaoPhase.PRODUCTION;
    }
  }
  return phase;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {'/': (_) => MyPage(), '/debug': (_) => DebugPage()},
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List<ApiItem> apiList = [];

  @override
  void initState() {
    super.initState();
    _initApiList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SDK Sample'),
        actions: [
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text('DEBUG'),
              ),
            ),
            onTap: () => Navigator.of(context).pushNamed('/debug'),
          )
        ],
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            ApiItem item = apiList[index];
            bool isHeader = item.apiFunction == null;
            return ListTile(
              title: Text(
                item.label,
                style: TextStyle(
                    color: isHeader
                        ? Theme.of(context).primaryColor
                        : Colors.black),
              ),
              onTap: apiList[index].apiFunction,
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: apiList.length),
    );
  }

  _initApiList() {
    apiList = [
      ApiItem('User API'),
      ApiItem('isKakaoTalkLoginAvailable()', () async {
        // 카카오톡 설치여부 확인
        bool result = await isKakaoTalkInstalled();
        String msg = result ? '카카오톡으로 로그인 가능' : '카카오톡 미설치: 카카오계정으로 로그인 사용 권장';
        Log.i(context, tag, msg);
      }),
      ApiItem('loginWithKakaoTalk()', () async {
        try {
          // 카카오톡으로 로그인
          OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
          Log.i(context, tag, '로그인 성공 ${token.accessToken}');
        } catch (e) {
          Log.e(context, tag, '로그인 실패', e);
        }
      }),
      ApiItem('certLoginWithKakaoTalk()', () async {
        try {
          // 카카오톡으로 인증서 로그인
          CertTokenInfo certTokenInfo =
              await UserApi.instance.certLoginWithKakaoTalk(state: "test");
          Log.i(context, tag,
              '로그인 성공 ${certTokenInfo.token.accessToken} ${certTokenInfo.txId}');
        } catch (e) {
          Log.e(context, tag, '로그인 실패', e);
        }
      }),
      ApiItem('loginWithKakaoAccount()', () async {
        try {
          // 카카오계정으로 로그인
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          Log.i(context, tag, '로그인 성공 ${token.accessToken}');
        } catch (e) {
          Log.e(context, tag, '로그인 실패', e);
        }
      }),
      ApiItem('loginWithKakaoAccount()', () async {
        try {
          // 카카오계정으로 로그인 - 재인증
          OAuthToken token = await UserApi.instance
              .loginWithKakaoAccount(prompts: [Prompt.login]);
          Log.i(context, tag, '로그인 성공 ${token.accessToken}');
        } catch (e) {
          Log.e(context, tag, '로그인 실패', e);
        }
      }),
      ApiItem('certLoginWithKakaoAccount()', () async {
        try {
          // 카카오계정으로 인증서 로그인
          CertTokenInfo certTokenInfo =
              await UserApi.instance.certLoginWithKakaoAccount(state: "test");
          Log.i(context, tag,
              '로그인 성공 ${certTokenInfo.token.accessToken} ${certTokenInfo.txId}');
        } catch (e) {
          Log.e(context, tag, '로그인 실패', e);
        }
      }),
      ApiItem('Combination Login', () async {
        try {
          // 로그인 조합 예제
          bool talkInstalled = await isKakaoTalkInstalled();

          // 카카오톡이 설치되어 있으면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
          OAuthToken token = talkInstalled
              ? await UserApi.instance.loginWithKakaoTalk()
              : await UserApi.instance.loginWithKakaoAccount();
          Log.i(context, tag, '로그인 성공 ${token.accessToken}');
        } catch (e) {
          Log.e(context, tag, '로그인 실패', e);
        }
      }),
      ApiItem('Combination Login (Verbose)', () async {
        // 로그인 조합 예제 + 상세한 에러처리 콜백
        // TODO: exception 정리
        // try {
        //   bool talkInstalled = await isKakaoTalkInstalled();
        //   카카오톡이 설치되어 있으면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
        //   OAuthToken token = talkInstalled
        //       ? await UserApi.instance.loginWithKakaoTalk()
        //       : await UserApi.instance.loginWithKakaoAccount();
        //   Log.i(context, tag, '로그인 성공 ${token.accessToken}');
        // } on KakaoClientException catch (error) {
        //   switch(error.) {
        //     is KakaoClient
        //   }
        //   Log.e(context, tag, '로그인 실패', error);
        // }
      }),
      ApiItem('me()', () async {
        try {
          // 사용자 정보 요청 (기본)
          User user = await UserApi.instance.me();
          Log.i(
              context,
              tag,
              '사용자 정보 요청 성공'
              '\n회원번호: ${user.id}'
              '\n이메일: ${user.kakaoAccount?.email}'
              '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
              '\n프로필사진: ${user.kakaoAccount?.profile?.thumbnailImageUrl}');
        } catch (e) {
          Log.e(context, tag, '사용자 정보 요청 실패', e);
        }
      }),
      ApiItem('me() - new scopes', () async {
        // 사용자 정보 요청 (추가 동의)

        // 사용자가 로그인 시 제3자 정보제공에 동의하지 않은 개인정보 항목 중 어떤 정보가 반드시 필요한 시나리오에 진입한다면
        // 다음과 같이 추가 동의를 받고 해당 정보를 획득할 수 있습니다.

        //  * 주의: 선택 동의항목은 사용자가 거부하더라도 서비스 이용에 지장이 없어야 합니다.

        // 추가 권한 요청 시나리오 예제
        User user;
        try {
          user = await UserApi.instance.me();
        } catch (e) {
          Log.e(context, tag, '사용자 정보 요청 실패', e);
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
        if (user.kakaoAccount?.ciNeedsAgreement == true) {
          scopes.add("account_ci");
        }
        if (user.kakaoAccount?.legalNameNeedsAgreement == true) {
          scopes.add("legal_name");
        }
        if (user.kakaoAccount?.legalBirthDateNeedsAgreement == true) {
          scopes.add("legal_birth_date");
        }
        if (user.kakaoAccount?.legalGenderNeedsAgreement == true) {
          scopes.add("legal_gender");
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

        if (scopes.length > 0) {
          Log.d(context, tag, '사용자에게 추가 동의를 받아야 합니다.');

          OAuthToken token;
          try {
            token = await UserApi.instance.loginWithNewScopes(scopes);
            Log.i(context, tag, 'allowed scopes: ${token.scopes}');
          } catch (e) {
            Log.e(context, tag, "사용자 추가 동의 실패", e);
            return;
          }

          try {
            // 사용자 정보 재요청
            User user = await UserApi.instance.me();
            Log.i(
                context,
                tag,
                '사용자 정보 요청 성공'
                '\n회원번호: ${user.id}'
                '\n이메일: ${user.kakaoAccount?.email}'
                '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
                '\n프로필사진: ${user.kakaoAccount?.profile?.thumbnailImageUrl}');
          } catch (e) {
            Log.e(context, tag, '사용자 정보 요청 실패', e);
          }
        }
      }),
      ApiItem('signup()', () async {
        try {
          await UserApi.instance.signup();
          Log.i(context, tag, 'signup 성공');
        } catch (e) {
          Log.e(context, tag, 'signup 실패', e);
        }
      }),
      ApiItem('scopes()', () async {
        try {
          ScopeInfo scopeInfo = await UserApi.instance.scopes();
          Log.i(
              context, tag, '동의 정보 확인 성공\n현재 가지고 있는 동의 항목 ${scopeInfo.scopes}');
        } catch (e) {
          Log.e(context, tag, '동의 정보 확인 실패', e);
        }
      }),
      ApiItem('scopes() - optional', () async {
        try {
          ScopeInfo scopeInfo = await UserApi.instance.scopes();
          Log.i(
              context, tag, '동의 정보 확인 성공\n현재 가지고 있는 동의 항목 ${scopeInfo.scopes}');
        } catch (e) {
          Log.e(context, tag, '동의 정보 확인 실패', e);
        }
      }),
      ApiItem('revokeScopes()', () async {
        List<String> scopes = ['account_email', 'legal_birth_date', 'friends'];
        try {
          ScopeInfo scopeInfo = await UserApi.instance.revokeScopes(scopes);
          Log.i(context, tag, '동의 철회 성공\n현재 가지고 있는 동의 항목 ${scopeInfo.scopes}');
        } catch (e) {
          Log.e(context, tag, '동의 철회 실패', e);
        }
      }),
      ApiItem('accessTokenInfo()', () async {
        try {
          // 토큰 정보 보기
          AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
          Log.i(context, tag,
              '토큰 정보 보기 성공\n회원정보: ${tokenInfo.id}\n만료시간: ${tokenInfo.expiresIn} 초');
        } catch (e) {
          Log.e(context, tag, '동의 철회 실패', e);
        }
      }),
      ApiItem('updateProfile() - nickname', () async {
        try {
          // 사용자 정보 저장

          // 변경할 내용
          Map<String, String> properties = {'nickname': "${DateTime.now()}"};
          await UserApi.instance.updateProfile(properties);
          Log.i(context, tag, '사용자 정보 저장 성공');
        } catch (e) {
          Log.e(context, tag, '사용자 정보 저장 실패', e);
        }
      }),
      ApiItem('shippingAddresses()', () async {
        UserShippingAddresses userShippingAddress;
        try {
          // 배송지 조회 (추가 동의)
          userShippingAddress = await UserApi.instance.shippingAddresses();
        } catch (e) {
          Log.e(context, tag, '배송지 조회 실패', e);
          return;
        }

        if (userShippingAddress.shippingAddresses != null) {
          Log.i(context, tag,
              '배송지 조회 성공\n회원번호: ${userShippingAddress.userId}\n배송지: \n${userShippingAddress.shippingAddresses?.join('\n')}');
        } else if (!userShippingAddress.needsAgreement) {
          Log.e(context, tag,
              '사용자 계정에 배송지 없음. 꼭 필요하다면 동의항목 설정에서 수집 기능을 활성화 해보세요.');
        } else if (userShippingAddress.needsAgreement) {
          Log.d(context, tag, '사용자에게 배송지 제공 동의를 받아야 합니다.');

          List<String> scopes = ['shipping_address'];

          OAuthToken token;
          try {
            // 사용자에게 배송지 제공 동의 요청
            token = await UserApi.instance.loginWithNewScopes(scopes);
            Log.d(context, tag, 'allowed scopes: ${token.scopes}');
          } catch (e) {
            Log.e(context, tag, '배송지 제공 동의 실패', e);
          }

          try {
            UserShippingAddresses userShippingAddresses =
                await UserApi.instance.shippingAddresses();
            Log.i(context, tag,
                '배송지 조회 성공\n회원번호: ${userShippingAddresses.userId}\n${userShippingAddresses.shippingAddresses?.join('\n')}');
          } catch (e) {
            Log.e(context, tag, '배송지 조회 실패', e);
          }
        }
      }),
      ApiItem('serviceTerms()', () async {
        try {
          // 동의한 약관 확인하기
          UserServiceTerms userServiceTerms =
              await UserApi.instance.serviceTerms();
          Log.i(context, tag,
              '동의한 약관 확인하기 성공\n회원정보: ${userServiceTerms.userId}\n동의한 약관: \n${userServiceTerms.allowedServiceTerms?.join('\n')}');
        } catch (e) {
          Log.e(context, tag, '동의한 약관 확인하기 실패', e);
        }
      }),
      ApiItem('hasToken()', () async {
        // 로그아웃
        OAuthToken? token =
            await TokenManagerProvider.instance.manager.getToken();
        if (token == null) {
          Log.e(context, tag, 'SDK에 저장된 토큰 없음');
        } else {
          Log.i(context, tag, 'SDK에 저장된 토큰 있음');
        }
      }),
      ApiItem('logout()', () async {
        // 로그아웃
        try {
          await UserApi.instance.logout();
          Log.i(context, tag, '로그아웃 성공. SDK에서 토큰 삭제 됨');
        } catch (e) {
          Log.e(context, tag, '로그아웃 실패. SDK에서 토큰 삭제 됨', e);
        }
      }),
      ApiItem('unlink()', () async {
        try {
          // 연결 끊기
          await UserApi.instance.unlink();
          Log.i(context, tag, '연결 끊기 성공. SDK에서 토큰 삭제 됨');
        } catch (e) {
          Log.e(context, tag, '연결 끊기 실패', e);
        }
      }),
    ];
  }
}
