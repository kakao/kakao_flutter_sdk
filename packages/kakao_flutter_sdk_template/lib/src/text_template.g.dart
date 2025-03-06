// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextTemplate _$TextTemplateFromJson(Map<String, dynamic> json) => TextTemplate(
      text: json['text'] as String,
      link: Link.fromJson(json['link'] as Map<String, dynamic>),
      buttons: (json['buttons'] as List<dynamic>?)
          ?.map((e) => Button.fromJson(e as Map<String, dynamic>))
          .toList(),
      buttonTitle: json['button_title'] as String?,
      objectType: json['object_type'] as String? ?? "text",
    );

Map<String, dynamic> _$TextTemplateToJson(TextTemplate instance) =>
    <String, dynamic>{
      'text': instance.text,
      'link': instance.link.toJson(),
      if (instance.buttons?.map((e) => e.toJson()).toList() case final value?)
        'buttons': value,
      if (instance.buttonTitle case final value?) 'button_title': value,
      'object_type': instance.objectType,
    };
