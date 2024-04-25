import 'package:json_annotation/json_annotation.dart';

import 'item_info.dart';

part 'item_content.g.dart';

/// KO: 아이템 콘텐츠
/// <br>
/// EN: Item contents
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ItemContent {
  /// KO: 프로필 텍스트
  /// <br>
  /// EN: Profile text
  String? profileText;

  /// KO: 프로필 이미지 URL
  /// <br>
  /// EN: Profile image URL
  Uri? profileImageUrl;

  /// KO: 이미지 아이템 제목
  /// <br>
  /// EN: Title of the image item
  String? titleImageText;

  /// KO: 이미지 아이템 이미지 URL
  /// <br>
  /// EN: Image URL of the image item
  Uri? titleImageUrl;

  /// KO: 이미지 아이템의 카테고리
  /// <br>
  /// EN: Category of the image item
  String? titleImageCategory;

  /// KO: 아이템 정보
  /// <br>
  /// EN: Item information
  List<ItemInfo>? items;

  /// KO: 요약 정보
  /// <br>
  /// EN: Summary
  String? sum;

  /// KO: 합산 가격
  /// <br>
  /// EN: Total price
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
