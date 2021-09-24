import 'package:json_annotation/json_annotation.dart';

part 'feed_item.g.dart';

/// An object containing the contents of a list of items.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class FeedItem {
  /// Item name, up to 6 characters
  String? item;

  /// Item options and descriptions, up to 2 lines, up to 14 characters for 1 line, and up to 25 characters for 2 lines.
  String? itemOp;

  /// <nodoc>
  FeedItem({this.item, this.itemOp});

  /// <nodoc>
  factory FeedItem.fromJson(Map<String, dynamic> json) =>
      _$FeedItemFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$FeedItemToJson(this);
}
