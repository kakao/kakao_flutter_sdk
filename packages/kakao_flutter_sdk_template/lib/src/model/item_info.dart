import 'package:json_annotation/json_annotation.dart';

part 'item_info.g.dart';

/// KO: 아이템 정보
/// <br>
/// EN: Item information
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ItemInfo {
  /// KO: 아이템 이름
  /// <br>
  /// EN: Name of the item
  String item;

  /// KO: 아이템 가격
  /// <br>
  /// EN: Price of the item
  String itemOp;

  /// @nodoc
  ItemInfo({required this.item, required this.itemOp});

  /// @nodoc
  factory ItemInfo.fromJson(Map<String, dynamic> json) =>
      _$ItemInfoFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$ItemInfoToJson(this);
}
