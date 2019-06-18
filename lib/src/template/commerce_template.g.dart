// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commerce_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommerceTemplate _$CommerceTemplateFromJson(Map<String, dynamic> json) {
  return CommerceTemplate(
      json['content'] == null
          ? null
          : Content.fromJson(json['content'] as Map<String, dynamic>),
      json['commerce'] == null
          ? null
          : Commerce.fromJson(json['commerce'] as Map<String, dynamic>),
      buttons: (json['buttons'] as List)
          ?.map((e) =>
              e == null ? null : Button.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      objectType: json['object_type'] as String);
}

Map<String, dynamic> _$CommerceTemplateToJson(CommerceTemplate instance) =>
    <String, dynamic>{
      'content': instance.content?.toJson(),
      'commerce': instance.commerce?.toJson(),
      'buttons': instance.buttons?.map((e) => e?.toJson())?.toList(),
      'object_type': instance.objectType
    };
