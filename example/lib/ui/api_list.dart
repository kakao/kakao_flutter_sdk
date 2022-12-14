import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_example/custom_token_manager.dart';
import 'package:kakao_flutter_sdk_example/message_template.dart';
import 'package:kakao_flutter_sdk_example/model/api_item.dart';
import 'package:kakao_flutter_sdk_example/model/picker_item.dart';
import 'package:kakao_flutter_sdk_example/ui/friend_page.dart';
import 'package:kakao_flutter_sdk_example/util/log.dart';
import 'package:path_provider/path_provider.dart';

const String tag = "KakaoSdkSample";
const Map<String, int> templateIds = {
  "customMemo": 67020,
  "customMessage": 67020,
};

class ApiList extends StatefulWidget {
  const ApiList({Key? key}) : super(key: key);

  @override
  _ApiListState createState() => _ApiListState();
}

class _ApiListState extends State<ApiList> {
  List<ApiItem> apiList = [];
  Function(Friends?, Object?)? recursiveAppFriendsCompletion;

  @override
  void initState() {
    super.initState();
    _initApiList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          ApiItem item = apiList[index];
          bool isHeader = item.apiFunction == null;
          return ListTile(
            dense: isHeader,
            title: Text(
              item.label,
              style: TextStyle(
                  color:
                      isHeader ? Theme.of(context).primaryColor : Colors.black),
            ),
            onTap: apiList[index].apiFunction,
          );
        },
        separatorBuilder: (context, index) => const Divider(height: 1.0),
        itemCount: apiList.length);
  }

  _initApiList() {
    apiList = [
      ApiItem('User API'),
      ApiItem('isKakaoTalkInstalled()', () async {
        // 카카오톡 설치여부 확인

        bool result = await isKakaoTalkInstalled();
        String msg = result ? '카카오톡으로 로그인 가능' : '카카오톡 미설치: 카카오계정으로 로그인 사용 권장';
        Log.i(context, tag, msg);
      }),
      ApiItem('loginWithKakaoTalk()', () async {
        // 카카오톡으로 로그인

        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
          Log.i(context, tag, '로그인 성공 ${token.accessToken}');
        } catch (e) {
          Log.e(context, tag, '로그인 실패', e);
        }
      }),
      ApiItem('certLoginWithKakaoTalk()', () async {
        // 카카오톡으로 인증서 로그인

        try {
          CertTokenInfo certTokenInfo =
              await UserApi.instance.certLoginWithKakaoTalk(state: "test");
          Log.i(context, tag,
              '로그인 성공 ${certTokenInfo.token.accessToken} ${certTokenInfo.txId}');
        } catch (e) {
          Log.e(context, tag, '로그인 실패', e);
        }
      }),
      ApiItem('loginWithKakaoAccount()', () async {
        // 카카오계정으로 로그인

        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          Log.i(context, tag, '로그인 성공 ${token.accessToken}');
        } catch (e) {
          Log.e(context, tag, '로그인 실패', e);
        }
      }),
      ApiItem('loginWithKakaoAccount(prompts:login)', () async {
        // 카카오계정으로 로그인 - 재인증

        try {
          OAuthToken token = await UserApi.instance
              .loginWithKakaoAccount(prompts: [Prompt.login]);
          Log.i(context, tag, '로그인 성공 ${token.accessToken}');
        } catch (e) {
          Log.e(context, tag, '로그인 실패', e);
        }
      }),
      ApiItem('certLoginWithKakaoAccount()', () async {
        // 카카오계정으로 인증서 로그인

        try {
          CertTokenInfo certTokenInfo =
              await UserApi.instance.certLoginWithKakaoAccount(state: "test");
          Log.i(context, tag,
              '로그인 성공 ${certTokenInfo.token.accessToken} ${certTokenInfo.txId}');
        } catch (e) {
          Log.e(context, tag, '로그인 실패', e);
        }
      }),
      ApiItem('Combination Login', () async {
        // 로그인 조합 예제

        bool talkInstalled = await isKakaoTalkInstalled();

        // 카카오톡이 설치되어 있으면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
        if (talkInstalled) {
          try {
            OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
            Log.i(context, tag, '카카오톡으로 로그인 성공 ${token.accessToken}');
          } catch (e) {
            Log.e(context, tag, '카카오톡으로 로그인 실패', e);

            // 유저에 의해서 카카오톡으로 로그인이 취소된 경우 카카오계정으로 로그인 생략 (ex 뒤로가기)
            if (e is PlatformException && e.code == 'CANCELED') {
              return;
            }

            // 카카오톡에 로그인이 안되어있는 경우 카카오계정으로 로그인
            try {
              OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
              Log.i(context, tag, '카카오계정으로 로그인 성공 ${token.accessToken}');
            } catch (e) {
              Log.e(context, tag, '카카오계정으로 로그인 실패', e);
            }
          }
        } else {
          try {
            OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
            Log.i(context, tag, '카카오계정으로 로그인 성공 ${token.accessToken}');
          } catch (e) {
            Log.e(context, tag, '카카오계정으로 로그인 실패', e);
          }
        }
      }),
      ApiItem('Combination Login (Verbose)', () async {
        // 로그인 조합 예제 + 상세한 에러처리 콜백
        try {
          bool talkInstalled = await isKakaoTalkInstalled();
          //   카카오톡이 설치되어 있으면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
          OAuthToken token = talkInstalled
              ? await UserApi.instance.loginWithKakaoTalk()
              : await UserApi.instance.loginWithKakaoAccount();
          Log.i(context, tag, '로그인 성공 ${token.accessToken}');
        } on KakaoClientException catch (e) {
          Log.e(context, tag, '클라이언트 에러', e);
        } on KakaoAuthException catch (e) {
          if (e.error == AuthErrorCause.accessDenied) {
            Log.e(context, tag, '취소됨 (동의 취소)', e);
          } else if (e.error == AuthErrorCause.misconfigured) {
            Log.e(
                context,
                tag,
                '개발자사이트 앱 설정에 키 해시 또는 번들 ID를 등록하세요. 현재 값: ${await KakaoSdk.origin}',
                e);
          } else {
            Log.e(context, tag, '기타 인증 에러', e);
          }
        } catch (e) {
          // 에러처리에 대한 개선사항이 필요하면 데브톡(https://devtalk.kakao.com)으로 문의해주세요.
          Log.e(context, tag, '기타 에러 (네트워크 장애 등..)', e);
        }
      }),
      ApiItem('me()', () async {
        // 사용자 정보 요청 (기본)

        try {
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

          // 사용자 정보 재요청
          try {
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
        // 동의 항목 확인하기

        try {
          ScopeInfo scopeInfo = await UserApi.instance.scopes();
          Log.i(
              context, tag, '동의 정보 확인 성공\n현재 가지고 있는 동의 항목 ${scopeInfo.scopes}');
        } catch (e) {
          Log.e(context, tag, '동의 정보 확인 실패', e);
        }
      }),
      ApiItem('scopes() - optional', () async {
        // 특정 동의 항목 확인하기

        List<String> scopes = ['account_email', 'friends'];
        try {
          ScopeInfo scopeInfo = await UserApi.instance.scopes(scopes: scopes);
          Log.i(
              context, tag, '동의 정보 확인 성공\n현재 가지고 있는 동의 항목 ${scopeInfo.scopes}');
        } catch (e) {
          Log.e(context, tag, '동의 정보 확인 실패', e);
        }
      }),
      ApiItem('revokeScopes()', () async {
        List<String> scopes = ['account_email', 'friends'];
        try {
          ScopeInfo scopeInfo =
              await UserApi.instance.revokeScopes(scopes: scopes);
          Log.i(context, tag, '동의 철회 성공\n현재 가지고 있는 동의 항목 ${scopeInfo.scopes}');
        } catch (e) {
          Log.e(context, tag, '동의 철회 실패', e);
        }
      }),
      ApiItem('accessTokenInfo()', () async {
        // 토큰 정보 보기

        try {
          AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
          Log.i(context, tag,
              '토큰 정보 보기 성공\n회원정보: ${tokenInfo.id}\n만료시간: ${tokenInfo.expiresIn} 초');
        } catch (e) {
          Log.e(context, tag, '동의 철회 실패', e);
        }
      }),
      ApiItem('updateProfile()', () async {
        // 사용자 정보 저장

        try {
          // 변경할 내용
          Map<String, String> properties = {'custom_key': "${DateTime.now()}"};
          await UserApi.instance.updateProfile(properties);
          Log.i(context, tag, '사용자 정보 저장 성공');
        } catch (e) {
          Log.e(context, tag, '사용자 정보 저장 실패', e);
        }
      }),
      ApiItem('shippingAddresses()', () async {
        // 배송지 조회 (추가 동의)

        UserShippingAddresses userShippingAddress;
        try {
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

          // 사용자에게 배송지 제공 동의 요청
          OAuthToken token;
          try {
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
        // 동의한 약관 확인하기

        try {
          UserServiceTerms userServiceTerms =
              await UserApi.instance.serviceTerms();
          Log.i(context, tag,
              '동의한 약관 확인하기 성공\n회원정보: ${userServiceTerms.userId}\n동의한 약관: \n${userServiceTerms.allowedServiceTerms?.join('\n')}');
        } catch (e) {
          Log.e(context, tag, '동의한 약관 확인하기 실패', e);
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
        // 연결 끊기

        try {
          await UserApi.instance.unlink();
          Log.i(context, tag, '연결 끊기 성공. SDK에서 토큰 삭제 됨');
        } catch (e) {
          Log.e(context, tag, '연결 끊기 실패', e);
        }
      }),
      ApiItem('KakaoTalk API'),
      ApiItem('profile()', () async {
        // 카카오톡 프로필 받기

        try {
          TalkProfile profile = await TalkApi.instance.profile();
          Log.i(context, tag,
              '카카오톡 프로필 받기 성공\n닉네임: ${profile.nickname}\n프로필사진: ${profile.thumbnailUrl}\n국가코드: ${profile.countryISO}');
        } catch (e) {
          Log.e(context, tag, '카카오톡 프로필 받기 실패', e);
        }
      }),
      ApiItem('sendCustomMemo()', () async {
        // 커스텀 템플릿으로 나에게 보내기

        // 메시지 템플릿 아이디
        // * 만들기 가이드: https://developers.kakao.com/docs/latest/ko/message/message-template
        int templateId = templateIds['customMessage']!;

        try {
          await TalkApi.instance.sendCustomMemo(templateId: templateId);
          Log.i(context, tag, '나에게 보내기 성공');
        } catch (e) {
          Log.e(context, tag, '나에게 보내기 실패', e);
        }
      }),
      ApiItem('sendDefaultMemo()', () async {
        // 디폴트 템플릿으로 나에게 보내기 - Feed

        try {
          await TalkApi.instance.sendDefaultMemo(defaultFeed);
          Log.i(context, tag, '나에게 보내기 성공');
        } catch (e) {
          Log.e(context, tag, '나에게 보내기 실패', e);
        }
      }),
      ApiItem('sendScrapMemo()', () async {
        // 스크랩 템플릿으로 나에게 보내기

        // 공유할 웹페이지 URL
        //  * 주의: 개발자사이트 Web 플랫폼 설정에 공유할 URL의 도메인이 등록되어 있어야 합니다.
        String url = 'https://developers.kakao.com';

        try {
          await TalkApi.instance.sendScrapMemo(url: url);
          Log.i(context, tag, '나에게 보내기 성공');
        } catch (e) {
          Log.e(context, tag, '나에게 보내기 실패', e);
        }
      }),
      ApiItem('friends()', () async {
        // 카카오톡 친구 목록 받기 (기본)

        try {
          Friends friends = await TalkApi.instance.friends();
          Log.i(context, tag,
              '카카오톡 친구 목록 받기 성공\n${friends.elements?.map((e) => e.profileNickname).join('\n')}');

          // 친구의 UUID 로 메시지 보내기 가능
        } catch (e) {
          Log.e(context, tag, '카카오톡 친구 목록 받기 실패', e);
        }
      }),
      ApiItem("friends(order:) - desc", () async {
        // 카카오톡 친구 목록 받기 (파라미터)

        try {
          // 내림차순으로 받기
          Friends friends = await TalkApi.instance.friends(order: Order.desc);
          Log.i(context, tag,
              '카카오톡 친구 목록 받기 성공\n${friends.elements?.map((e) => e.profileNickname).join('\n')}');

          // 친구의 UUID 로 메시지 보내기 가능
        } catch (e) {
          Log.e(context, tag, '카카오톡 친구 목록 받기 실패', e);
        }
      }),
      ApiItem('friends(context:) - recursive', () async {
        FriendsContext nextFriendsContext = FriendsContext(
          offset: 0,
          limit: 3,
          order: Order.desc,
        );

        recursiveAppFriendsCompletion = (friends, error) async {
          if (error == null) {
            if (friends != null) {
              try {
                if (friends.afterUrl == null) {
                  return;
                }

                nextFriendsContext =
                    FriendsContext.fromUrl(Uri.parse(friends.afterUrl!));
              } catch (e) {
                return;
              }
            }

            try {
              Friends friends =
                  await TalkApi.instance.friends(context: nextFriendsContext);
              Log.i(context, tag,
                  '카카오톡 친구 목록 받기 성공\n${friends.elements?.map((e) => e.profileNickname).join('\n')}');
              recursiveAppFriendsCompletion?.call(friends, null);
            } catch (e) {
              Log.e(context, tag, '카카오톡 친구 목록 받기 실패');
            }
          }
        };

        recursiveAppFriendsCompletion?.call(null, null);
      }),
      ApiItem('friends(context:) - FriendContext', () async {
        try {
          Friends friends = await TalkApi.instance.friends(
              context: FriendsContext(offset: 0, limit: 1, order: Order.desc));
          Log.i(context, tag,
              '카카오톡 친구 목록 받기 성공\n${friends.elements?.join('\n')}');
        } catch (e) {
          Log.e(context, tag, '카카오톡 친구 목록 받기 실패', e);
        }
      }),
      ApiItem('sendCustomMessage()', () async {
        // 커스텀 템플릿으로 친구에게 메시지 보내기

        // 카카오톡 친구 목록 받기
        Friends friends;
        try {
          friends = await TalkApi.instance.friends();
        } catch (e) {
          Log.e(context, tag, '카카오톡 친구 목록 받기 실패', e);
          return;
        }

        if (friends.elements == null) {
          return;
        }

        if (friends.elements!.isEmpty) {
          Log.e(context, tag, '메시지 보낼 친구가 없습니다');
        } else {
          // 서비스에 상황에 맞게 메시지 보낼 친구의 UUID 를 가져오세요.
          // 이 샘플에서는 친구 목록을 화면에 보여주고 체크박스로 선택된 친구들의 UUID 를 수집하도록 구현했습니다.
          List<String> selectedItems = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FriendPage(
                items: friends.elements!
                    .map((friend) => PickerItem(
                        friend.uuid,
                        friend.profileNickname ?? '',
                        friend.profileThumbnailImage))
                    .toList(),
              ),
            ),
          );

          if (selectedItems.isEmpty) {
            return;
          }
          Log.d(context, tag, '선택된 친구:\n${selectedItems.join('\n')}');

          // 메시지 보낼 친구의 UUID 목록
          List<String> receiverUuids = selectedItems;

          // 메시지 템플릿 아이디
          // * 만들기 가이드: https://developers.kakao.com/docs/latest/ko/message/message-template
          int templateId = templateIds['customMessage']!;

          // 메시지 보내기
          try {
            MessageSendResult result = await TalkApi.instance.sendCustomMessage(
              receiverUuids: receiverUuids,
              templateId: templateId,
            );
            Log.i(context, tag, '메시지 보내기 성공 ${result.successfulReceiverUuids}');

            if (result.failureInfos != null) {
              Log.d(context, tag,
                  '메시지 보내기에 일부 성공했으나, 일부 대상에게는 실패 \n${result.failureInfos}');
            }
          } catch (e) {
            Log.e(context, tag, '메시지 보내기 실패', e);
          }
        }
      }),
      ApiItem('sendDefaultMessage()', () async {
        // 디폴트 템플릿으로 친구에게 메시지 보내기 - Feed

        // 카카오톡 친구 목록 받기
        Friends friends;
        try {
          friends = await TalkApi.instance.friends();
        } catch (e) {
          Log.e(context, tag, '카카오톡 친구 목록 받기 실패', e);
          return;
        }

        if (friends.elements == null) {
          return;
        }

        if (friends.elements!.isEmpty) {
          Log.e(context, tag, '메시지 보낼 친구가 없습니다');
        } else {
          // 서비스에 상황에 맞게 메시지 보낼 친구의 UUID 를 가져오세요.
          // 이 샘플에서는 친구 목록을 화면에 보여주고 체크박스로 선택된 친구들의 UUID 를 수집하도록 구현했습니다.
          List<String> selectedItems = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FriendPage(
                items: friends.elements!
                    .map((friend) => PickerItem(
                        friend.uuid,
                        friend.profileNickname ?? '',
                        friend.profileThumbnailImage))
                    .toList(),
              ),
            ),
          );

          if (selectedItems.isEmpty) {
            return;
          }
          Log.d(context, tag, '선택된 친구:\n${selectedItems.join('\n')}');

          // 메시지 보낼 친구의 UUID 목록
          List<String> receiverUuids = selectedItems;

          // Feed 메시지
          FeedTemplate template = defaultFeed;

          // 메시지 보내기
          try {
            MessageSendResult result =
                await TalkApi.instance.sendDefaultMessage(
              receiverUuids: receiverUuids,
              template: template,
            );
            Log.i(context, tag, '메시지 보내기 성공 ${result.successfulReceiverUuids}');

            if (result.failureInfos != null) {
              Log.d(context, tag,
                  '메시지 보내기에 일부 성공했으나, 일부 대상에게는 실패 \n${result.failureInfos}');
            }
          } catch (e) {
            Log.e(context, tag, '메시지 보내기 실패', e);
          }
        }
      }),
      ApiItem('sendDefaultMessage() - calendar', () async {
        // 디폴트 템플릿으로 친구에게 메시지 보내기 - calendar

        // 카카오톡 친구 목록 받기
        Friends friends;
        try {
          friends = await TalkApi.instance.friends();
        } catch (e) {
          Log.e(context, tag, '카카오톡 친구 목록 받기 실패', e);
          return;
        }

        if (friends.elements == null) {
          return;
        }

        if (friends.elements!.isEmpty) {
          Log.e(context, tag, '메시지 보낼 친구가 없습니다');
        } else {
          // 서비스에 상황에 맞게 메시지 보낼 친구의 UUID 를 가져오세요.
          // 이 샘플에서는 친구 목록을 화면에 보여주고 체크박스로 선택된 친구들의 UUID 를 수집하도록 구현했습니다.
          List<String> selectedItems = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FriendPage(
                items: friends.elements!
                    .map((friend) => PickerItem(
                        friend.uuid,
                        friend.profileNickname ?? '',
                        friend.profileThumbnailImage))
                    .toList(),
              ),
            ),
          );

          if (selectedItems.isEmpty) {
            return;
          }
          Log.d(context, tag, '선택된 친구:\n${selectedItems.join('\n')}');

          // 메시지 보낼 친구의 UUID 목록
          List<String> receiverUuids = selectedItems;

          // Calendar 메시지
          CalendarTemplate template = defaultCalendar;

          // 메시지 보내기
          try {
            MessageSendResult result =
                await TalkApi.instance.sendDefaultMessage(
              receiverUuids: receiverUuids,
              template: template,
            );
            Log.i(context, tag, '메시지 보내기 성공 ${result.successfulReceiverUuids}');

            if (result.failureInfos != null) {
              Log.d(context, tag,
                  '메시지 보내기에 일부 성공했으나, 일부 대상에게는 실패 \n${result.failureInfos}');
            }
          } catch (e) {
            Log.e(context, tag, '메시지 보내기 실패', e);
          }
        }
      }),
      ApiItem('sendScrapMessage()', () async {
        // 스크랩 템플릿으로 친구에게 메시지 보내기

        // 카카오톡 친구 목록 받기
        Friends friends;
        try {
          friends = await TalkApi.instance.friends();
        } catch (e) {
          Log.e(context, tag, '카카오톡 친구 목록 받기 실패', e);
          return;
        }

        if (friends.elements == null) {
          return;
        }

        if (friends.elements!.isEmpty) {
          Log.e(context, tag, '메시지 보낼 친구가 없습니다');
        } else {
          // 서비스에 상황에 맞게 메시지 보낼 친구의 UUID 를 가져오세요.
          // 이 샘플에서는 친구 목록을 화면에 보여주고 체크박스로 선택된 친구들의 UUID 를 수집하도록 구현했습니다.
          List<String> selectedItems = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FriendPage(
                items: friends.elements!
                    .map((friend) => PickerItem(
                        friend.uuid,
                        friend.profileNickname ?? '',
                        friend.profileThumbnailImage))
                    .toList(),
              ),
            ),
          );

          if (selectedItems.isEmpty) {
            return;
          }
          Log.d(context, tag, '선택된 친구:\n${selectedItems.join('\n')}');

          // 메시지 보낼 친구의 UUID 목록
          List<String> receiverUuids = selectedItems;

          // 공유할 웹페이지 URL
          //  * 주의: 개발자사이트 Web 플랫폼 설정에 공유할 URL의 도메인이 등록되어 있어야 합니다.
          String url = "https://developers.kakao.com";

          // 메시지 보내기
          try {
            MessageSendResult result = await TalkApi.instance.sendScrapMessage(
              receiverUuids: receiverUuids,
              url: url,
            );
            Log.i(context, tag, '메시지 보내기 성공 ${result.successfulReceiverUuids}');

            if (result.failureInfos != null) {
              Log.d(context, tag,
                  '메시지 보내기에 일부 성공했으나, 일부 대상에게는 실패 \n${result.failureInfos}');
            }
          } catch (e) {
            Log.e(context, tag, '메시지 보내기 실패', e);
          }
        }
      }),
      ApiItem('channels()', () async {
        // 카카오톡 채널 관계 확인하기

        try {
          Channels relations = await TalkApi.instance.channels();
          Log.i(context, tag, '채널 관계 확인 성공\n${relations.channels}');
        } catch (e) {
          Log.e(context, tag, '채널 관계 확인 실패', e);
        }
      }),
      ApiItem('addChannelUrl()', () async {
        // 카카오톡 채널 추가하기 URL
        Uri url = await TalkApi.instance.addChannelUrl('_ZeUTxl');

        // 디바이스 브라우저 열기
        try {
          await launchBrowserTab(url);
        } catch (e) {
          Log.e(context, tag, '카카오톡 채널 추가 실패', e);
        }
      }),
      ApiItem('channelChatUrl()', () async {
        // 카카오톡 채널 채팅 URL
        Uri url = await TalkApi.instance.channelChatUrl('_ZeUTxl');

        // 디바이스 브라우저 열기
        try {
          await launchBrowserTab(url);
        } catch (e) {
          Log.e(context, tag, '카카오톡 채널 채팅 실패', e);
        }
      }),
      ApiItem('KakaoStory API'),
      ApiItem('isStoryUser()', () async {
        // 카카오스토리 사용자 확인하기

        try {
          bool isStoryUser = await StoryApi.instance.isStoryUser();
          Log.i(context, tag, '카카오스토리 가입 여부: $isStoryUser');
        } catch (e) {
          Log.e(context, tag, '카카오스토리 사용자 확인 실패', e);
        }
      }),
      ApiItem('profile()', () async {
        // 카카오스토리 프로필 받기

        try {
          StoryProfile profile = await StoryApi.instance.profile();
          Log.i(context, tag,
              '카카오스토리 프로필 받기 성공\n닉네임: ${profile.nickname}\n프로필사진: ${profile.thumbnailUrl}\n생일: ${profile.birthday}');
        } catch (e) {
          Log.e(context, tag, '카카오스토리 프로필 받기 실패', e);
        }
      }),
      ApiItem('stories()', () async {
        // 여러 개의 스토리 받기

        try {
          List<Story> stories = await StoryApi.instance.stories();
          Log.i(context, tag, '스토리 받기 성공\n$stories');
        } catch (e) {
          Log.e(context, tag, '스토리 받기 실패', e);
        }
      }),
      ApiItem('story(id:) - first of stories', () async {
        // 지정 스토리 받기

        // 이 샘플에서는 받고자 하는 스토리 아이디를 얻기 위해 전체 목록을 조회하고 첫번째 스토리 아이디를 사용했습니다.
        List<Story> stories;
        try {
          stories = await StoryApi.instance.stories();
        } catch (e) {
          return;
        }

        if (stories.isEmpty) {
          Log.e(context, tag, '내 스토리가 하나도 없습니다');
          return;
        }

        // 정보를 원하는 스토리 아이디
        String storyId = stories.first.id;

        // 지정 스토리 받기
        try {
          Story story = await StoryApi.instance.story(storyId);
          Log.i(context, tag,
              '스토리 받기 성공\n아이디: ${story.id}\n미디어 형식: ${story.mediaType}\n작성일자: ${story.createdAt}\n내용: ${story.content}');
        } catch (e) {
          Log.e(context, tag, '스토리 받기 실패', e);
        }
      }),
      ApiItem('delete(id:) - first of stories', () async {
        // 내 스토리 삭제하기

        // 이 샘플에서는 삭제하고자 하는 스토리 아이디를 얻기 위해 전체 목록을 조회하고 첫번째 스토리 아이디를 사용했습니다.
        List<Story> stories;

        try {
          stories = await StoryApi.instance.stories();
        } catch (e) {
          Log.e(context, tag, '스토리 받기 실패', e);
          return;
        }

        if (stories.isEmpty) {
          Log.e(context, tag, '내 스토리가 하나도 없습니다');
          return;
        }

        // 삭제를 원하는 스토리 아이디
        String storyId = stories.first.id;

        // 스토리 삭제하기
        try {
          await StoryApi.instance.delete(storyId);
          Log.i(context, tag, '스토리 삭제 성공 [$storyId]');
        } catch (e) {
          Log.e(context, tag, '스토리 삭제 실패', e);
        }
      }),
      ApiItem('postNote()', () async {
        // 글 스토리 쓰기

        try {
          String content = "Posting note from Kakao SDK Sample";
          StoryPostResult storyPostResult =
              await StoryApi.instance.postNote(content: content);
          Log.i(context, tag, '스토리 쓰기 성공 [${storyPostResult.id}]');
        } catch (e) {
          Log.e(context, tag, '스토리 쓰기 실패', e);
        }
      }),
      ApiItem('postLink()', () async {
        // 링크 스토리 쓰기

        LinkInfo linkInfo;
        try {
          linkInfo =
              await StoryApi.instance.linkInfo('https://www.kakaocorp.com');
          Log.d(context, tag, '링크 만들기 성공 ${linkInfo.title}');
        } catch (e) {
          Log.e(context, tag, '링크 만들기 실패', e);
          return;
        }

        String content = 'Posting link from Kakao SDK Sample.';

        try {
          StoryPostResult storyPostResult = await StoryApi.instance
              .postLink(linkInfo: linkInfo, content: content);
          Log.i(context, tag, '스토리 쓰기 성공 [${storyPostResult.id}]');
        } catch (e) {
          Log.e(context, tag, '스토리 쓰기 실패', e);
        }
      }),
      ApiItem('postPhoto()', () async {
        // 사진 스토리 쓰기

        // 이 샘플에서는 프로젝트 리소스로 추가한 이미지 파일을 사용했습니다. 갤러리 등 서비스 니즈에 맞는 사진 파일을 준비하세요.
        // 업로드할 사진 파일
        ByteData byteData = await rootBundle.load('assets/images/cat1.png');

        // 이 샘플에서는 path_provider를 사용해 프로젝트 리소스를 이미지 파일로 저장했습니다.
        File tempFile =
            File('${(await getTemporaryDirectory()).path}/cat1.png');
        File file = await tempFile.writeAsBytes(byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

        // 사진 업로드
        List<String> images;

        try {
          images = await StoryApi.instance.upload([file]);
          Log.d(context, tag, '사진 업로드 성공 $images');
        } catch (e) {
          Log.e(context, tag, '사진 업로드 실패', e);
          return;
        }

        // 사진 스토리 쓰기
        try {
          String content = 'Posting photo from Kakao SDK Sample.';
          StoryPostResult storyPostResult = await StoryApi.instance
              .postPhoto(images: images, content: content);
          Log.i(context, tag, '스토리 쓰기 성공 [${storyPostResult.id}]');
        } catch (e) {
          Log.e(context, tag, '스토리 쓰기 실패', e);
        }
      }),
      ApiItem('KakaoTalk Sharing API'),
      ApiItem('isKakaoTalkSharingAvailable()', () async {
        // 카카오톡 설치여부 확인
        bool result = await ShareClient.instance.isKakaoTalkSharingAvailable();
        if (result) {
          Log.i(context, tag, '카카오톡 공유 가능');
        } else {
          Log.i(context, tag, '카카오톡 미설치: 웹 공유 사용 권장');
        }
      }),
      ApiItem('customTemplate()', () async {
        // 커스텀 템플릿으로 카카오톡 공유하기
        //  * 만들기 가이드: https://developers.kakao.com/docs/latest/ko/message/message-template
        int templateId = templateIds['customMemo']!;

        try {
          Uri uri =
              await ShareClient.instance.shareCustom(templateId: templateId);
          await ShareClient.instance.launchKakaoTalk(uri);
          Log.d(context, tag, '카카오톡 공유 성공');
        } catch (e) {
          Log.e(context, tag, '카카오톡 공유 실패', e);
        }
      }),
      ApiItem('scrapTemplate()', () async {
        // 스크랩 템플릿으로 카카오톡 공유하기

        // 공유할 웹페이지 URL
        // * 주의: 개발자사이트 Web 플랫폼 설정에 공유할 URL의 도메인이 등록되어 있어야 합니다.
        String url = "https://developers.kakao.com";

        try {
          Uri uri = await ShareClient.instance.shareScrap(url: url);
          await ShareClient.instance.launchKakaoTalk(uri);
          Log.d(context, tag, '카카오톡 공유 성공');
        } catch (e) {
          Log.e(context, tag, '카카오톡 공유 실패', e);
        }
      }),
      ApiItem('defaultTemplate() - feed', () async {
        // 디폴트 템플릿으로 카카오톡 공유하기 - Feed

        try {
          Uri uri =
              await ShareClient.instance.shareDefault(template: defaultFeed);
          await ShareClient.instance.launchKakaoTalk(uri);
          Log.d(context, tag, '카카오톡 공유 성공');
        } catch (e) {
          Log.e(context, tag, '카카오톡 공유 실패', e);
        }
      }),
      ApiItem('defaultTemplate() - list', () async {
        // 디폴트 템플릿으로 카카오톡 공유하기 - List

        try {
          Uri uri =
              await ShareClient.instance.shareDefault(template: defaultList);
          await ShareClient.instance.launchKakaoTalk(uri);
          Log.d(context, tag, '카카오톡 공유 성공');
        } catch (e) {
          Log.e(context, tag, '카카오톡 공유 실패', e);
        }
      }),
      ApiItem('defaultTemplate() - location', () async {
        // 디폴트 템플릿으로 카카오톡 공유하기 - Location

        try {
          Uri uri = await ShareClient.instance
              .shareDefault(template: defaultLocation);
          await ShareClient.instance.launchKakaoTalk(uri);
          Log.d(context, tag, '카카오톡 공유 성공');
        } catch (e) {
          Log.e(context, tag, '카카오톡 공유 실패', e);
        }
      }),
      ApiItem('defaultTemplate() - commerce', () async {
        // 디폴트 템플릿으로 카카오톡 공유하기 - Commerce

        try {
          Uri uri = await ShareClient.instance
              .shareDefault(template: defaultCommerce);
          await ShareClient.instance.launchKakaoTalk(uri);
          Log.d(context, tag, '카카오톡 공유 성공');
        } catch (e) {
          Log.e(context, tag, '카카오톡 공유 실패', e);
        }
      }),
      ApiItem('defaultTemplate() - text', () async {
        // 디폴트 템플릿으로 카카오톡 공유하기 - Text

        try {
          Uri uri =
              await ShareClient.instance.shareDefault(template: defaultText);
          await ShareClient.instance.launchKakaoTalk(uri);
          Log.d(context, tag, '카카오톡 공유 성공');
        } catch (e) {
          Log.e(context, tag, '카카오톡 공유 실패', e);
        }
      }),
      ApiItem('defaultTemplate() - calendar', () async {
        // 디폴트 템플릿으로 카카오톡 공유하기 - Calendar

        try {
          Uri uri = await ShareClient.instance
              .shareDefault(template: defaultCalendar);
          await ShareClient.instance.launchKakaoTalk(uri);
          Log.d(context, tag, '카카오톡 공유 성공');
        } catch (e) {
          Log.e(context, tag, '카카오톡 공유 실패', e);
        }
      }),
      ApiItem('customTemplateUri() - web sharer', () async {
        // 커스텀 템플릿으로 웹에서 카카오톡 공유하기

        // 메시지 템플릿 아이디
        // * 만들기 가이드: https://developers.kakao.com/docs/latest/ko/message/message-template
        int templateId = templateIds['customMemo']!;

        try {
          Uri shareUrl = await WebSharerClient.instance.makeCustomUrl(
              templateId: templateId, templateArgs: {'key1': 'value1'});
          await launchBrowserTab(shareUrl);
        } catch (e) {
          Log.e(context, tag, '카카오톡 공유 실패', e);
        }
      }),
      ApiItem('scrapTemplateUri() - web sharer', () async {
        // 스크랩 템플릿으로 웹에서 카카오톡 공유하기

        // 공유할 웹페이지 URL
        // * 주의: 개발자사이트 Web 플랫폼 설정에 공유할 URL의 도메인이 등록되어 있어야 합니다.
        String url = "https://developers.kakao.com";

        try {
          Uri shareUrl = await WebSharerClient.instance
              .makeScrapUrl(url: url, templateArgs: {'key1': 'value1'});
          await launchBrowserTab(shareUrl);
        } catch (e) {
          Log.e(context, tag, '카카오톡 공유 실패', e);
        }
      }),
      ApiItem('defaultTemplateUri() - web sharer - feed', () async {
        // 커스텀 템플릿으로 웹에서 카카오톡 공유하기 - Feed

        try {
          Uri shareUrl = await WebSharerClient.instance
              .makeDefaultUrl(template: defaultFeed);
          await launchBrowserTab(shareUrl);
        } catch (e) {
          Log.e(context, tag, '카카오톡 공유 실패', e);
        }
      }),
      ApiItem('defaultTemplateUri() - web sharer - location', () async {
        // 커스텀 템플릿으로 웹에서 카카오톡 공유하기 - Location

        try {
          Uri shareUrl = await WebSharerClient.instance
              .makeDefaultUrl(template: defaultLocation);
          await launchBrowserTab(shareUrl);
        } catch (e) {
          Log.e(context, tag, '카카오톡 공유 실패', e);
        }
      }),
      ApiItem('defaultTemplateUri() - web sharer - calendar', () async {
        // 커스텀 템플릿으로 웹에서 카카오톡 공유하기 - Feed

        try {
          Uri shareUrl = await WebSharerClient.instance
              .makeDefaultUrl(template: defaultCalendar);
          await launchBrowserTab(shareUrl);
        } catch (e) {
          Log.e(context, tag, '카카오톡 공유 실패', e);
        }
      }),
      ApiItem('uploadImage() - File', () async {
        // 이미지 업로드

        // 로컬 이미지 파일
        // 이 샘플에서는 프로젝트 리소스로 추가한 이미지 파일을 사용했습니다. 갤러리 등 서비스 니즈에 맞는 사진 파일을 준비하세요.
        ByteData byteData = await rootBundle.load('assets/images/cat1.png');

        // 이 샘플에서는 path_provider를 사용해 프로젝트 리소스를 이미지 파일로 저장했습니다.
        File tempFile =
            File('${(await getTemporaryDirectory()).path}/cat1.png');
        File file = await tempFile.writeAsBytes(byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

        try {
          // 카카오 이미지 서버로 업로드
          ImageUploadResult imageUploadResult =
              await ShareClient.instance.uploadImage(image: file);
          Log.i(
              context, tag, '이미지 업로드 성공\n${imageUploadResult.infos.original}');
        } catch (e) {
          Log.e(context, tag, '이미지 업로드 실패', e);
        }
      }),
      ApiItem('uploadImage() - ByteData', () async {
        // 이미지 업로드

        // 이 샘플에서는 file_picker를 사용해 이미지 파일을 가져왔습니다.
        var filePickerResult =
            await FilePicker.platform.pickFiles(withData: true);

        if (filePickerResult != null) {
          var byteData = filePickerResult.files.first.bytes;

          try {
            // 카카오 이미지 서버로 업로드
            ImageUploadResult imageUploadResult =
                await ShareClient.instance.uploadImage(byteData: byteData);
            Log.i(context, tag,
                '이미지 업로드 성공\n${imageUploadResult.infos.original}');
          } catch (e) {
            Log.e(context, tag, '이미지 업로드 실패', e);
          }
        }
      }),
      ApiItem('scrapImage()', () async {
        // 이미지 스크랩

        // 원본 원격 이미지 URL
        String url =
            'https://t1.kakaocdn.net/kakaocorp/Service/KakaoTalk/pc/slide/talkpc_theme_01.jpg';

        try {
          // 카카오 이미지 서버로 업로드
          ImageUploadResult imageUploadResult =
              await ShareClient.instance.scrapImage(imageUrl: url);
          Log.i(
              context, tag, '이미지 스크랩 성공\n${imageUploadResult.infos.original}');
        } catch (e) {
          Log.e(context, tag, '이미지 스크랩 실패', e);
        }
      }),
      ApiItem('KakaoNavi API'),
      ApiItem('isKakaoNaviInstalled()', () async {
        // 카카오내비 설치여부 확인
        bool result = await NaviApi.instance.isKakaoNaviInstalled();
        if (result) {
          Log.i(context, tag, '카카오내비 앱으로 길안내 가능');
        } else {
          Log.i(context, tag, '카카오내비 미설치');
        }
      }),
      ApiItem('shareDestination - KATEC', () async {
        if (await NaviApi.instance.isKakaoNaviInstalled()) {
          // 카카오내비 앱으로 목적지 공유하기 - KATEC
          await NaviApi.instance.shareDestination(
            destination: Location(name: '카카오 판교오피스', x: '321286', y: '533707'),
          );
        } else {
          // 카카오내비 설치 페이지로 이동
          launchBrowserTab(Uri.parse(NaviApi.webNaviInstall));
        }
      }),
      ApiItem('shareDestination - WGS84', () async {
        if (await NaviApi.instance.isKakaoNaviInstalled()) {
          // 카카오내비 앱으로 목적지 공유하기 - WGS84
          await NaviApi.instance.shareDestination(
            destination:
                Location(name: '카카오 판교오피스', x: '127.108640', y: '37.402111'),
            option: NaviOption(coordType: CoordType.wgs84),
          );
        } else {
          // 카카오내비 설치 페이지로 이동
          launchBrowserTab(Uri.parse(NaviApi.webNaviInstall));
        }
      }),
      ApiItem('navigate - KATEC - viaList', () async {
        if (await NaviApi.instance.isKakaoNaviInstalled()) {
          // 카카오내비 앱으로 목적지 공유하기 - KATEC - 경유지 추가
          await NaviApi.instance.navigate(
            destination: Location(name: '카카오 판교오피스', x: '321286', y: '533707'),
            viaList: [
              Location(name: '판교역 1번출구', x: '321525', y: '532951'),
            ],
          );
        } else {
          // 카카오내비 설치 페이지로 이동
          launchBrowserTab(Uri.parse(NaviApi.webNaviInstall));
        }
      }),
      ApiItem('navigate - WGS84 - viaList', () async {
        if (await NaviApi.instance.isKakaoNaviInstalled()) {
          // 카카오내비 앱으로 목적지 공유하기 - WGS84 - 경유지 추가
          await NaviApi.instance.navigate(
            destination:
                Location(name: '카카오 판교오피스', x: '127.108640', y: '37.402111'),
            viaList: [
              Location(name: '판교역 1번출구', x: '127.111492', y: '37.395225'),
            ],
          );
        } else {
          // 카카오내비 설치 페이지로 이동
          launchBrowserTab(Uri.parse(NaviApi.webNaviInstall));
        }
      }),
      ApiItem('Kakao Sync'),
      ApiItem('login(serviceTerms:) - select one', () async {
        // 약관 선택해 동의 받기

        // 개발자사이트 간편가입 설정에 등록한 약관 목록 중, 동의 받기를 원하는 약관의 태그 값을 지정합니다.
        List<String> serviceTerms = ['service'];

        try {
          OAuthToken token = await UserApi.instance
              .loginWithKakaoTalk(serviceTerms: serviceTerms);
          Log.i(context, tag, '로그인 성공 ${token.accessToken}');
        } catch (e) {
          Log.e(context, tag, '로그인 실패', e);
        }
      }),
      ApiItem('login(serviceTerms:) - empty', () async {
        // 약관 동의 받지 않기

        try {
          // serviceTerms 파라미터에 empty list 전달해서 카카오톡으로 로그인 요청 (카카오계정으로 로그인도 사용법 동일)
          OAuthToken token =
              await UserApi.instance.loginWithKakaoTalk(serviceTerms: []);
          Log.i(context, tag, '로그인 성공 ${token.accessToken}');
        } catch (e) {
          Log.e(context, tag, '로그인 실패', e);
        }
      }),
      ApiItem('OIDC'),
      ApiItem('loginWithKakaoTalk(nonce:openidtest)', () async {
        // 카카오톡으로 로그인 - openId

        try {
          OAuthToken token =
              await UserApi.instance.loginWithKakaoTalk(nonce: 'openidtest');
          Log.i(context, tag, '로그인 성공 idToken: ${token.idToken}');
        } catch (e) {
          Log.e(context, tag, '로그인 실패', e);
        }
      }),
      ApiItem('certLoginWithKakaoTalk(nonce:openidtest)', () async {
        // 카카오톡으로 인증서 로그인 - openId

        try {
          CertTokenInfo certTokenInfo = await UserApi.instance
              .certLoginWithKakaoTalk(state: 'test', nonce: 'openidtest');
          Log.i(context, tag,
              '로그인 성공\nidToken: ${certTokenInfo.token.idToken}\ntxId: ${certTokenInfo.txId}');
        } catch (e) {
          Log.e(context, tag, '로그인 실패', e);
        }
      }),
      ApiItem('loginWithKakaoAccount(nonce:openidtest)', () async {
        // 카카오계정으로 로그인 - openId

        try {
          OAuthToken token =
              await UserApi.instance.loginWithKakaoAccount(nonce: 'openidtest');
          Log.i(context, tag, '로그인 성공 idToken: ${token.idToken}');
        } catch (e) {
          Log.e(context, tag, '로그인 실패', e);
        }
      }),
      ApiItem('certLoginWithKakaoAccount(nonce:openidtest)', () async {
        // 카카오계정으로 인증서 로그인 - openId

        try {
          CertTokenInfo certTokenInfo = await UserApi.instance
              .certLoginWithKakaoAccount(state: 'test', nonce: 'openidtest');
          Log.i(context, tag,
              '로그인 성공\nidToken: ${certTokenInfo.token.idToken}\ntxId:${certTokenInfo.txId}');
        } catch (e) {
          Log.e(context, tag, '로그인 실패', e);
        }
      }),
      ApiItem('me() - new scopes(nonce:openidtest)', () async {
        // 사용자 정보 요청 (추가 동의)

        // 사용자가 로그인 시 제3자 정보제공에 동의하지 않은 개인정보 항목 중 어떤 정보가 반드시 필요한 시나리오에 진입한다면
        // 다음과 같이 추가 동의를 받고 해당 정보를 획득할 수 있습니다.

        //  * 주의: 선택 동의항목은 사용자가 거부하더라도 서비스 이용에 지장이 없어야 합니다.

        // 추가 권한 요청 시나리오 예제

        User user;
        try {
          user = await UserApi.instance.me();
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

          // OpenID 활성화 후
          // - scope 파라메터에 openid 항목을 포함하여 요청할 경우 OIDC로 동작
          // - scope 파라메터에 openid 항목을 미포함 시 OAuth2.0 으로 동작

          // OIDC 요청이므로 "openid" 항목을 추가한다
          scopes.add('openid');

          OAuthToken token;
          try {
            token = await UserApi.instance
                .loginWithNewScopes(scopes, nonce: 'openidtest');
            Log.i(context, tag, 'allowed scopes: ${token.scopes}');
          } catch (e) {
            Log.e(context, tag, "사용자 추가 동의 실패", e);
            return;
          }

          // 사용자 정보 재요청
          try {
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
      ApiItem('ETC'),
      ApiItem('Get Current Token', () async {
        // 현재 토큰 저장소에서 토큰 가져오기
        Log.i(context, tag,
            '${await TokenManagerProvider.instance.manager.getToken()}');
      }),
      ApiItem('Set Custom TokenManager', () async {
        // 커스텀 토큰 저장소 설정
        TokenManagerProvider.instance.manager = CustomTokenManager();
        Log.i(context, tag, '커스텀 토큰 저장소 사용');
      }),
      ApiItem('Set Default TokenManager', () async {
        // 기본 저장소 재설정
        TokenManagerProvider.instance.manager = DefaultTokenManager();
        Log.i(context, tag, '기본 토큰 저장소 설정');
      }),
      ApiItem('hasToken() usage', () async {
        if (await AuthApi.instance.hasToken()) {
          try {
            AccessTokenInfo tokenInfo =
                await UserApi.instance.accessTokenInfo();
            Log.i(context, tag,
                '토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');
          } catch (e) {
            if (e is KakaoException && e.isInvalidTokenError()) {
              Log.e(context, tag, '토큰이 만료되었습니다.', e);
            } else {
              Log.e(context, tag, '토큰 정보를 가져오는데 실패했습니다', e);
            }

            try {
              // 카카오 계정으로 로그인
              OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
              Log.i(context, tag, '로그인 성공 ${token.accessToken}');
            } catch (e) {
              Log.e(context, tag, '로그인 실패', e);
            }
          }
        } else {
          Log.i(context, tag, '토큰이 없습니다.');
          try {
            OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
            Log.i(context, tag, '로그인 성공 ${token.accessToken}');
          } catch (e) {
            Log.e(context, tag, '로그인 실패', e);
          }
        }
      }),
    ];
  }
}
