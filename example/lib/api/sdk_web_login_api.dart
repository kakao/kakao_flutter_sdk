import 'package:example/model/list_item.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import '../model/custom_data.dart';

const String _tag = "Web Login API";

// 개발 환경에 따라 redirectUri 설정이 필요합니다. (예시는 로컬 서버 주소로 설정되어 있습니다.)
const String _redirectUri = 'http://172.20.29.239:3000/redirect';

List<ListItem> createWebLoginApis(CustomData customData) => <ListItem>[
  const Header(_tag),
  Api('authorizeWithTalk()', (context) async {
    await AuthCodeClient.instance.authorizeWithTalk(redirectUri: _redirectUri);
  }, showResult: false),
  Api('authorize()', (context) async {
    await AuthCodeClient.instance.authorize(redirectUri: _redirectUri);
  }, showResult: false),
  Api('authorizeWithNewScopes()', (context) async {
    await AuthCodeClient.instance.authorizeWithNewScopes(
      redirectUri: _redirectUri,
      scopes: customData.scopes,
    );
  }),
];
