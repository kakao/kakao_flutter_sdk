import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk_share/src/constants.dart';
import 'package:kakao_flutter_sdk_share/src/model/picker_settings.dart';
import 'package:kakao_flutter_sdk_share/src/model/share_type.dart';
import 'package:kakao_flutter_sdk_share/src/share_api.dart';
import 'package:kakao_flutter_sdk_share/src/share_client.dart';
import 'package:kakao_flutter_sdk_share/src/share_platform.dart';

import '../../kakao_flutter_sdk_common/test/shared/doubles/fake_common_platform.dart';
import '../../kakao_flutter_sdk_common/test/shared/utils/test_kakao_http_client.dart';

class FakeSharePlatform extends SharePlatform {
  String? launchedUrl;

  @override
  Future<bool> isKakaoTalkSharingAvailable() async => true;

  @override
  Future<void> launchKakaoTalk(String url) async => launchedUrl = url;

  @override
  Map<String, String> platformExtras() => <String, String>{};
}

/// 스킴 쿼리 문자열을 키/값 맵으로 되돌린다.
Map<String, String> _parseQuery(String url) {
  final query = url.substring(url.indexOf('?') + 1);
  return <String, String>{
    for (final pair in query.split('&'))
      pair.substring(0, pair.indexOf('=')): pair.substring(
        pair.indexOf('=') + 1,
      ),
  };
}

void main() {
  late TestKakaoHttpClient httpClient;
  late FakeSharePlatform platform;
  late ShareClient client;

  setUp(() async {
    await KakaoSdk.init(
      nativeAppKey: 'test-app-key',
      platformProvider: FakeCommonPlatform(),
    );

    httpClient = TestKakaoHttpClient();
    platform = FakeSharePlatform();
    client = ShareClient(api: ShareApi(httpClient), platform: platform);
  });

  test('picker_extras is carried into the talk scheme', () async {
    httpClient.enqueueJson(<String, dynamic>{
      'template_id': 4718,
      'template_msg': <String, dynamic>{
        'P': <String, dynamic>{},
        'C': <String, dynamic>{},
      },
      'warning_msg': <String, dynamic>{},
      'argument_msg': <String, dynamic>{},
      'scheme_params': <String, dynamic>{'list': 'chat', 'limit': 5},
      'picker_extras': <String, dynamic>{'show_send_to_me': false},
    });

    await client.shareCustom(
      templateId: 4718,
      pickerSettings: const PickerSettings(
        type: ShareType.chat,
        limit: 5,
        showSendToMe: false,
      ),
    );

    final query = _parseQuery(platform.launchedUrl!);
    expect(query[Constants.list], 'chat');
    expect(query[Constants.limit], '5');
    expect(
      jsonDecode(Uri.decodeComponent(query[Constants.pickerExtras]!)),
      <String, dynamic>{Constants.showSendToMe: false},
    );
  });

  test('picker_extras is omitted when the response has none', () async {
    httpClient.enqueueJson(<String, dynamic>{
      'template_id': 4718,
      'template_msg': <String, dynamic>{
        'P': <String, dynamic>{},
        'C': <String, dynamic>{},
      },
      'warning_msg': <String, dynamic>{},
      'argument_msg': <String, dynamic>{},
      'scheme_params': <String, dynamic>{'list': 'chat'},
    });

    await client.shareCustom(templateId: 4718);

    final query = _parseQuery(platform.launchedUrl!);
    expect(query.containsKey(Constants.pickerExtras), false);
    expect(query.containsKey(Constants.showSendToMe), false);
  });

  test('picker_extras is omitted when the response value is empty', () async {
    httpClient.enqueueJson(<String, dynamic>{
      'template_id': 4718,
      'template_msg': <String, dynamic>{
        'P': <String, dynamic>{},
        'C': <String, dynamic>{},
      },
      'warning_msg': <String, dynamic>{},
      'argument_msg': <String, dynamic>{},
      'picker_extras': <String, dynamic>{},
    });

    await client.shareCustom(templateId: 4718);

    final query = _parseQuery(platform.launchedUrl!);
    expect(query.containsKey(Constants.pickerExtras), false);
  });
}
