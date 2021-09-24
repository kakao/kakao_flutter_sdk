// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedItem _$FeedItemFromJson(Map<String, dynamic> json) {
  return FeedItem(
    item: json['item'] as String?,
    itemOp: json['item_op'] as String?,
  );
}

Map<String, dynamic> _$FeedItemToJson(FeedItem instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('item', instance.item);
  writeNotNull('item_op', instance.itemOp);
  return val;
}
