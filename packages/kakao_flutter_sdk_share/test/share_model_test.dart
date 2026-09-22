import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_share/src/model/image_infos.dart';
import 'package:kakao_flutter_sdk_share/src/model/image_upload_result.dart';
import 'package:kakao_flutter_sdk_share/src/model/picker_settings.dart';
import 'package:kakao_flutter_sdk_share/src/model/share_type.dart';

void main() {
  test('ImageUploadResult json serialization', () {
    final json = <String, dynamic>{
      'infos': {
        'original': {
          'url': 'https://image.kakao.com/image.png',
          'content_type': 'image/png',
          'length': 1234,
          'width': 100,
          'height': 200,
        },
      },
    };

    final result = ImageUploadResult.fromJson(json);
    expect(result.infos.original.url, 'https://image.kakao.com/image.png');
    expect(result.infos.original.contentType, 'image/png');
    expect(result.infos.original.length, 1234);
    final encoded = result.toJson();
    final infos = encoded['infos'] as ImageInfos;
    expect(infos.original.toJson(), json['infos']!['original']);
  });

  test('PickerSettings splits scheme params and picker extras', () {
    const settings = PickerSettings(
      type: ShareType.chat,
      limit: 3,
      showSendToMe: false,
    );

    expect(settings.toSchemeParams(), <String, dynamic>{
      'list': 'chat',
      'limit': 3,
    });
    expect(settings.toPickerExtras(), <String, dynamic>{
      'show_send_to_me': false,
    });
  });

  test('PickerSettings serializes defaultType as default', () {
    expect(
      const PickerSettings(type: ShareType.defaultType).toSchemeParams(),
      <String, dynamic>{'list': 'default'},
    );
  });

  test('PickerSettings omits unset properties', () {
    expect(const PickerSettings().toSchemeParams(), <String, dynamic>{});
    expect(const PickerSettings().toPickerExtras(), <String, dynamic>{});
    expect(
      const PickerSettings(showSendToMe: true).toSchemeParams(),
      <String, dynamic>{},
    );
  });
}
