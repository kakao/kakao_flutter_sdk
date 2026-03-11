import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_share/src/constants.dart';
import 'package:kakao_flutter_sdk_share/src/share_api.dart';
import 'package:kakao_flutter_sdk_template/src/model/link.dart';
import 'package:kakao_flutter_sdk_template/src/text_template.dart';

import '../../kakao_flutter_sdk_common/test/shared/utils/load_data.dart';
import '../../kakao_flutter_sdk_common/test/shared/utils/test_kakao_http_client.dart';

void main() {
  late TestKakaoHttpClient client;
  late ShareApi api;

  setUp(() {
    client = TestKakaoHttpClient();
    api = ShareApi(client);
  });

  test('send custom 200', () async {
    final path = uriPathToFilePath(
      '${Constants.validatePath}/${Constants.validate}',
    );
    final body = await loadJson('share/$path/normal.json');
    final map = jsonDecode(body);

    client.enqueueJson(map);

    final response = await api.custom(4718, templateArgs: {'key1': 'value1'});
    expect(response.templateId, map['template_id']);
  });

  // test('send custom with shareType and limit', () async {
  //   final path = uriPathToFilePath(
  //     '${Constants.validatePath}/${Constants.validate}',
  //   );
  //   final body = await loadJson('share/$path/normal.json');
  //   final map = jsonDecode(body);
  //   client.enqueueJson(map);
  //
  //   await api.custom(4718, templateArgs: {'key1': 'value1'});
  //
  //   final query = client.lastRequest.queryParameters!;
  //   expect(
  //     client.lastRequest.path,
  //     '${Constants.validatePath}/${Constants.validate}',
  //   );
  //   expect(query[Constants.templateId], 4718);
  //   expect(query[Constants.templateArgs], '{"key1":"value1"}');
  //   expect(
  //     jsonDecode(query[Constants.schemeParams] as String),
  //     <String, dynamic>{
  //       Constants.list: ShareType.chat.value,
  //       Constants.limit: 3,
  //     },
  //   );
  // });

  test('send default template', () async {
    final map = <String, dynamic>{
      'template_id': 4718,
      'template_msg': <String, dynamic>{},
      'warning_msg': <String, dynamic>{},
      'argument_msg': <String, dynamic>{},
    };
    client.enqueueJson(map);

    final template = TextTemplate(
      text: 'hello',
      link: Link(webUrl: Uri.parse('https://developers.kakao.com')),
    );

    final response = await api.defaultTemplate(template);

    final query = client.lastRequest.queryParameters!;
    final templateObject = jsonDecode(
      query[Constants.templateObject] as String,
    );
    expect(response.templateId, map['template_id']);
    expect(templateObject['object_type'], 'text');
    // expect(
    //   jsonDecode(query[Constants.schemeParams] as String),
    //   <String, dynamic>{
    //     Constants.list: ShareType.friend.value,
    //     Constants.limit: 2,
    //   },
    // );
  });

  test('send scrap', () async {
    final map = <String, dynamic>{
      'template_id': 4718,
      'template_msg': <String, dynamic>{},
      'warning_msg': <String, dynamic>{},
      'argument_msg': <String, dynamic>{},
    };
    client.enqueueJson(map);

    final response = await api.scrap(
      'https://developers.kakao.com',
      templateId: 4718,
      templateArgs: {'key1': 'value1'},
    );

    final query = client.lastRequest.queryParameters!;
    expect(
      client.lastRequest.path,
      '${Constants.validatePath}/${Constants.scrap}',
    );
    expect(response.templateId, map['template_id']);
    expect(query[Constants.requestUrl], 'https://developers.kakao.com');
    expect(query[Constants.templateId], 4718);
    expect(query[Constants.templateArgs], '{"key1":"value1"}');
    // expect(
    //   jsonDecode(query[Constants.schemeParams] as String),
    //   <String, dynamic>{
    //     Constants.list: ShareType.defaultType.value,
    //     Constants.limit: 1,
    //   },
    // );
  });

  test('upload image with byte data', () async {
    client.enqueueJson({
      'infos': {
        'original': {
          'url': 'https://image.kakao.com/image.png',
          'content_type': 'image/png',
          'length': 1234,
          'width': 100,
          'height': 200,
        },
      },
    });

    final response = await api.uploadImage(
      null,
      Uint8List.fromList([1, 2, 3]),
      true,
    );

    final formData = client.lastRequest.data as FormData;
    expect(client.lastRequest.path, Constants.uploadImagePath);
    expect(formData.files.single.key, Constants.file);
    expect(formData.fields.single.key, Constants.secureResource);
    expect(formData.fields.single.value, 'true');
    expect(response.infos.original.url, 'https://image.kakao.com/image.png');
  });

  test('scrap image', () async {
    client.enqueueJson({
      'infos': {
        'original': {
          'url': 'https://image.kakao.com/scrap.png',
          'content_type': 'image/png',
          'length': 2345,
          'width': 120,
          'height': 220,
        },
      },
    });

    final response = await api.scrapImage(
      'https://developers.kakao.com/image.png',
      false,
    );

    expect(client.lastRequest.path, Constants.scrapImagePath);
    expect(client.lastRequest.data, <String, String>{
      Constants.imageUrl: 'https://developers.kakao.com/image.png',
      Constants.secureResource: 'false',
    });
    expect(response.infos.original.length, 2345);
  });
}
