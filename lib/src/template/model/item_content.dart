import 'package:json_annotation/json_annotation.dart';

import 'item_info.dart';

part 'item_content.g.dart';

/// An object containing the contents of a list of items.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ItemContent {
  /// Text to be output to the header or profile area. If there is no [profileImageUrl] value, it is printed in the form of a header with only a bold title, up to 16 characters.
  String? profileText;

  /// An image to be output to the profile area. It's printed in the form of a small circular profile image.
  String? profileImageUrl;

  /// The title of the image item. Up to 2 lines. Up to 24 characters.
  String? titleImageText;

  /// Image of an image item. 108*108 on iOS and 98*98 on Android. Images that are not 1:1 ratio are readjusted in a center crop.
  String? titleImageUrl;

  /// Category information output in gray letters under the title of the image item. Up to one line. Up to 14 characters.
  String? titleImageCategory;

  /// Each text item information. JSON arrangement including [ItemInfo.item] and [ItemInfo.itemOp] corresponding to the item name and price, supporting up to 5 items.
  List<ItemInfo>? items;

  /// Summary information title of item area such as order amount and payment amount. Output up to 6 characters under text item area.
  String? sum;

  /// Price sum information of item area. Output up to 11 characters in bold under text item area.
  String? sumOp;

  /// <nodoc>
  ItemContent(
      {this.profileText,
      this.profileImageUrl,
      this.titleImageText,
      this.titleImageUrl,
      this.titleImageCategory,
      this.items,
      this.sum,
      this.sumOp});

  /// <nodoc>
  factory ItemContent.fromJson(Map<String, dynamic> json) =>
      _$ItemContentFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$ItemContentToJson(this);
}
