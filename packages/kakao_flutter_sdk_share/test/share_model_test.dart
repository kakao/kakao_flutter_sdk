import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_share/src/model/image_infos.dart';
import 'package:kakao_flutter_sdk_share/src/model/image_upload_result.dart';

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
}
