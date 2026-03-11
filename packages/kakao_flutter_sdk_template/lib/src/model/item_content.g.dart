// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemContent _$ItemContentFromJson(Map<String, dynamic> json) => ItemContent(
  profileText: json['profile_text'] as String?,
  profileImageUrl: json['profile_image_url'] == null
      ? null
      : Uri.parse(json['profile_image_url'] as String),
  titleImageText: json['title_image_text'] as String?,
  titleImageUrl: json['title_image_url'] == null
      ? null
      : Uri.parse(json['title_image_url'] as String),
  titleImageCategory: json['title_image_category'] as String?,
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => ItemInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
  sum: json['sum'] as String?,
  sumOp: json['sum_op'] as String?,
);

Map<String, dynamic> _$ItemContentToJson(ItemContent instance) =>
    <String, dynamic>{
      'profile_text': ?instance.profileText,
      'profile_image_url': ?instance.profileImageUrl?.toString(),
      'title_image_text': ?instance.titleImageText,
      'title_image_url': ?instance.titleImageUrl?.toString(),
      'title_image_category': ?instance.titleImageCategory,
      'items': ?instance.items,
      'sum': ?instance.sum,
      'sum_op': ?instance.sumOp,
    };
