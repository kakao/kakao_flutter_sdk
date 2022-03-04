// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemInfo _$ItemInfoFromJson(Map<String, dynamic> json) {
  return ItemInfo(
    item: json['item'] as String,
    itemOp: json['item_op'] as String,
  );
}

Map<String, dynamic> _$ItemInfoToJson(ItemInfo instance) => <String, dynamic>{
      'item': instance.item,
      'item_op': instance.itemOp,
    };
