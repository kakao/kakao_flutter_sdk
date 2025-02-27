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
      if (instance.profileText case final value?) 'profile_text': value,
      if (instance.profileImageUrl?.toString() case final value?)
        'profile_image_url': value,
      if (instance.titleImageText case final value?) 'title_image_text': value,
      if (instance.titleImageUrl?.toString() case final value?)
        'title_image_url': value,
      if (instance.titleImageCategory case final value?)
        'title_image_category': value,
      if (instance.items case final value?) 'items': value,
      if (instance.sum case final value?) 'sum': value,
      if (instance.sumOp case final value?) 'sum_op': value,
    };
