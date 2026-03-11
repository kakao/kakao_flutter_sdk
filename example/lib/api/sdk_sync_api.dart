import 'package:example/model/list_item.dart';
import 'package:example/util/log.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart';

const String _tag = 'SyncApi';

final syncApis = <ListItem>[
  const Header(_tag),
  Api('login(serviceTerms:) - select one', (context) async {
    // 약관 선택해 동의 받기
    // 개발자사이트 간편가입 설정에 등록한 약관 목록 중 동의 받기를 원하는 태그를 지정합니다.
    final serviceTerms = <String>['service'];

    try {
      final token = await UserApi.instance.loginWithKakaoTalk(
        serviceTerms: serviceTerms,
      );
      Log.i(_tag, '로그인 성공 ${token.accessToken}');
    } catch (e) {
      Log.e(_tag, '로그인 실패', e);
    }
  }),
  Api('login(serviceTerms:) - empty', (context) async {
    // 약관 동의 받지 않기
    // serviceTerms 파라미터에 empty list 전달해서 카카오톡으로 로그인 요청
    // (카카오계정으로 로그인도 사용법 동일)
    try {
      final token = await UserApi.instance.loginWithKakaoTalk(
        serviceTerms: const [],
      );
      Log.i(_tag, '로그인 성공 ${token.accessToken}');
    } catch (e) {
      Log.e(_tag, '로그인 실패', e);
    }
  }),
  const Header('OIDC'),
  Api('loginWithKakaoTalk(nonce:openidtest)', (context) async {
    // 카카오톡으로 로그인 - openid
    try {
      final token = await UserApi.instance.loginWithKakaoTalk(
        nonce: 'openidtest',
      );
      Log.i(_tag, '로그인 성공 idToken: ${token.idToken}');
    } catch (e) {
      Log.e(_tag, '로그인 실패', e);
    }
  }),
  Api('loginWithKakaoAccount(nonce:openidtest)', (context) async {
    // 카카오계정으로 로그인 - openid
    try {
      final token = await UserApi.instance.loginWithKakaoAccount(
        nonce: 'openidtest',
      );
      Log.i(_tag, '로그인 성공 idToken: ${token.idToken}');
    } catch (e) {
      Log.e(_tag, '로그인 실패', e);
    }
  }),
  Api('me() - new scopes(nonce:openidtest)', (context) async {
    // 사용자 정보 요청 (추가 동의)
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

    final scopes = <String>[];

    if (user.kakaoAccount?.emailNeedsAgreement == true) {
      scopes.add('account_email');
    }
    if (user.kakaoAccount?.birthdayNeedsAgreement == true) {
      scopes.add('birthday');
    }
    if (user.kakaoAccount?.birthyearNeedsAgreement == true) {
      scopes.add('birthyear');
    }
    if (user.kakaoAccount?.phoneNumberNeedsAgreement == true) {
      scopes.add('phone_number');
    }
    if (user.kakaoAccount?.profileNeedsAgreement == true) {
      scopes.add('profile');
    }
    if (user.kakaoAccount?.ageRangeNeedsAgreement == true) {
      scopes.add('age_range');
    }

    if (scopes.isEmpty) {
      return;
    }

    Log.d(_tag, '사용자에게 추가 동의를 받아야 합니다.');

    // OIDC 요청을 위해 openid scope를 추가합니다.
    scopes.add('openid');

    try {
      final token = await UserApi.instance.loginWithNewScopes(
        scopes,
        nonce: 'openidtest',
      );
      Log.i(_tag, 'allowed scopes: ${token.scopes}');
    } catch (e) {
      Log.e(_tag, '사용자 추가 동의 실패', e);
      return;
    }

    try {
      final userResponse = await UserApi.instance.me();
      Log.i(
        _tag,
        '사용자 정보 요청 성공'
        '\n회원번호: ${userResponse.id}'
        '\n이메일: ${userResponse.kakaoAccount?.email}'
        '\n닉네임: ${userResponse.kakaoAccount?.profile?.nickname}'
        '\n프로필사진: ${userResponse.kakaoAccount?.profile?.thumbnailImageUrl}',
      );
    } catch (e) {
      Log.e(_tag, '사용자 정보 요청 실패', e);
    }
  }),
];
