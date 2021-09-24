import 'package:json_annotation/json_annotation.dart';

import 'feed_item.dart';

part 'feed.g.dart';

/// An object containing the contents of a list of items.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Feed {
  /// Text to be output in header or profile area. If there is no [profileImageUrl] value, it is output in the form of a header containing only the title in bold, up to 16 characters.
  String? profileText;

  /// An image to be output to the profile area. It's printed in the form of a small circular profile image.
  String? profileImageUrl;

  /// Title of the item list. Up to 2 lines. Up to 24 characters.
  String? titleImageText;

  /// Title image of the item list. 108*108 on iOS and 98*98 on Android. Images that are not 1:1 ratio are readjusted in a center crop.
  String? titleImageUrl;

  /// Category information displayed in gray text under the title of the item list. Up to one line. Up to 14 characters.
  String? titleImageCategory;

  /// Item information on the item list. JSON array including item name [FeedItem.item], option and description [FeedItem.itemOp], , support up to 5 items.
  List<FeedItem>? items;

  /// Title of the overall information on the item list. Printed at the end of the item list. Print up to 6 characters.
  String? sum;

  /// Contents of the overall information on the item list. Printed in bold at the end of the item list. Print up to 11 characters.
  String? sumOp;

  /// <nodoc>
  Feed(
      {this.profileText,
      this.profileImageUrl,
      this.titleImageText,
      this.titleImageUrl,
      this.titleImageCategory,
      this.items,
      this.sum,
      this.sumOp});

  /// <nodoc>
  factory Feed.fromJson(Map<String, dynamic> json) => _$FeedFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$FeedToJson(this);
}
