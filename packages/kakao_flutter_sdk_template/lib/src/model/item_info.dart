import 'package:json_annotation/json_annotation.dart';

part 'item_info.g.dart';

/// 아이템 목록 형태의 콘텐츠의 내용을 담고 있는 오브젝트
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ItemInfo {
  /// 아이템 이름, 최대 6자까지 출력
  String item;

  /// 아이템 이름, 최대 6자까지 출력
  String itemOp;

  /// @nodoc
  ItemInfo({required this.item, required this.itemOp});

  /// @nodoc
  factory ItemInfo.fromJson(Map<String, dynamic> json) =>
      _$ItemInfoFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$ItemInfoToJson(this);
}
