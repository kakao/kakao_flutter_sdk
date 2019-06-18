// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextTemplate _$TextTemplateFromJson(Map<String, dynamic> json) {
  return TextTemplate(
      json['text'] as String,
      json['link'] == null
          ? null
          : Link.fromJson(json['link'] as Map<String, dynamic>),
      buttonTitle: json['button_title'] as String,
      buttons: (json['buttons'] as List)
          ?.map((e) =>
              e == null ? null : Button.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      objectType: json['object_type'] as String);
}

Map<String, dynamic> _$TextTemplateToJson(TextTemplate instance) =>
    <String, dynamic>{
      'text': instance.text,
      'link': instance.link?.toJson(),
      'button_title': instance.buttonTitle,
      'buttons': instance.buttons?.map((e) => e?.toJson())?.toList(),
      'object_type': instance.objectType
    };
