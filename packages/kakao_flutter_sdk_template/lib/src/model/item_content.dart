import 'package:json_annotation/json_annotation.dart';

import 'item_info.dart';

part 'item_content.g.dart';

/// 아이템 목록 형태의 콘텐츠의 내용을 담고 있는 오브젝트
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ItemContent {
  /// 헤더 또는 프로필 영역에 출력될 텍스트
  /// [profileImageUrl] 값이 없을 경우, 볼드(Bold)체로 된 제목만 담은 헤더 형태로 출력됨, 최대 16자까지 출력
  String? profileText;

  /// 프로필 영역에 출력될 이미지
  /// 작은 원형의 프로필 사진 형태로 출력됨
  Uri? profileImageUrl;

  /// 이미지 아이템의 제목
  /// 최대 2줄, 최대 24자까지 출력
  String? titleImageText;

  /// 이미지 아이템의 이미지
  /// iOS 108*108, Android 98*98 크기 1:1 비율이 아닌 이미지는 센터 크롭(Center crop) 방식으로 재조정됨
  Uri? titleImageUrl;

  /// 이미지 아이템의 제목 아래에 회색 글씨로 출력되는 카테고리 정보
  /// 최대 한 줄, 최대 14자까지 출력
  String? titleImageCategory;

  /// 각 텍스트 아이템 정보
  /// 아이템 이름과 가격에 해당하는 [ItemInfo.item], [ItemInfo.itemOp]를 포함한 JSON 배열, 최대 5개의 아이템 지원
  List<ItemInfo>? items;

  /// 주문금액, 결제금액 등 아이템 영역의 요약 정보 제목
  /// 텍스트 아이템 영역 아래에 최대 6자까지 출력
  String? sum;

  /// 아이템 영역의 가격 합산 정보
  /// 텍스트 아이템 영역 아래에 볼드체로 최대 11자까지 출력
  String? sumOp;

  /// @nodoc
  ItemContent({
    this.profileText,
    this.profileImageUrl,
    this.titleImageText,
    this.titleImageUrl,
    this.titleImageCategory,
    this.items,
    this.sum,
    this.sumOp,
  });

  /// @nodoc
  factory ItemContent.fromJson(Map<String, dynamic> json) =>
      _$ItemContentFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$ItemContentToJson(this);
}
