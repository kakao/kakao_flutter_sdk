// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedTemplate _$FeedTemplateFromJson(Map<String, dynamic> json) => FeedTemplate(
  content: Content.fromJson(json['content'] as Map<String, dynamic>),
  itemContent: json['item_content'] == null
      ? null
      : ItemContent.fromJson(json['item_content'] as Map<String, dynamic>),
  social: json['social'] == null
      ? null
      : Social.fromJson(json['social'] as Map<String, dynamic>),
  buttons: (json['buttons'] as List<dynamic>?)
      ?.map((e) => Button.fromJson(e as Map<String, dynamic>))
      .toList(),
  buttonTitle: json['button_title'] as String?,
  objectType: json['object_type'] as String? ?? 'feed',
);

Map<String, dynamic> _$FeedTemplateToJson(FeedTemplate instance) =>
    <String, dynamic>{
      'content': instance.content.toJson(),
      'item_content': ?instance.itemContent?.toJson(),
      'social': ?instance.social?.toJson(),
      'buttons': ?instance.buttons?.map((e) => e.toJson()).toList(),
      'button_title': ?instance.buttonTitle,
      'object_type': instance.objectType,
    };
