import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_template/src/model/item_content.dart';
import 'package:kakao_flutter_sdk_template/src/model/item_info.dart';
import 'package:kakao_flutter_sdk_template/src/model/link.dart';

void main() {
  test('Link converts execution params to/from query string', () {
    final link = Link(
      webUrl: Uri.parse('https://developers.kakao.com'),
      mobileWebUrl: Uri.parse('https://m.developers.kakao.com'),
      androidExecutionParams: {'key1': 'value1', 'key2': 'value2'},
      iosExecutionParams: {'key3': 'value3'},
    );

    final json = link.toJson();
    expect(json['web_url'], 'https://developers.kakao.com');
    expect(json['mobile_web_url'], 'https://m.developers.kakao.com');
    expect(json['android_execution_params'], 'key1=value1&key2=value2');
    expect(json['ios_execution_params'], 'key3=value3');

    final decoded = Link.fromJson({
      'android_execution_params': 'key1=value1&key2=value2',
      'ios_execution_params': 'key3=value3',
    });
    expect(decoded.androidExecutionParams, {'key1': 'value1', 'key2': 'value2'});
    expect(decoded.iosExecutionParams, {'key3': 'value3'});
  });

  test('ItemContent serializes optional fields only when present', () {
    final content = ItemContent(
      profileText: 'profile',
      profileImageUrl: Uri.parse('https://image.kakao.com/profile.png'),
      titleImageText: 'title',
      titleImageUrl: Uri.parse('https://image.kakao.com/title.png'),
      titleImageCategory: 'category',
      items: [
        ItemInfo(item: '상품명', itemOp: '10,000원'),
        ItemInfo(item: '배송비', itemOp: '무료'),
      ],
      sum: '합계',
      sumOp: '10,000원',
    );

    final json = content.toJson();
    expect(json['profile_text'], 'profile');
    expect(json['profile_image_url'], 'https://image.kakao.com/profile.png');
    final items = json['items'] as List<ItemInfo>;
    expect(items[0].toJson(), {'item': '상품명', 'item_op': '10,000원'});
    expect(items[1].toJson(), {'item': '배송비', 'item_op': '무료'});
    expect(json['sum_op'], '10,000원');

    final emptyJson = ItemContent().toJson();
    expect(emptyJson.isEmpty, true);
  });

  test('ItemContent and ItemInfo fromJson', () {
    final content = ItemContent.fromJson({
      'profile_text': 'profile',
      'title_image_text': 'title',
      'items': [
        {'item': '상품명', 'item_op': '10,000원'},
      ],
      'sum': '합계',
      'sum_op': '10,000원',
    });

    expect(content.profileText, 'profile');
    expect(content.titleImageText, 'title');
    expect(content.items, isNotNull);
    expect(content.items!.single.item, '상품명');
    expect(content.items!.single.itemOp, '10,000원');
    expect(content.sum, '합계');
    expect(content.sumOp, '10,000원');
  });
}
