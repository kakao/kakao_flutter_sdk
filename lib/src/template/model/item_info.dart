import 'package:json_annotation/json_annotation.dart';

part 'item_info.g.dart';

/// An object containing the contents of a list of items.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ItemInfo {
  /// Item name. up to 6 characters
  String item;

  /// Item price. Available characters: numbers, currency symbols, commas (,), periods (), spaces. If the decimal unit amount is included, only two digits below the decimal point are recommended.
  String itemOp;

  /// <nodoc>
  ItemInfo({required this.item, required this.itemOp});

  /// <nodoc>
  factory ItemInfo.fromJson(Map<String, dynamic> json) =>
      _$ItemInfoFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$ItemInfoToJson(this);
}
