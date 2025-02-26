// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commerce_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommerceTemplate _$CommerceTemplateFromJson(Map<String, dynamic> json) =>
    CommerceTemplate(
      content: Content.fromJson(json['content'] as Map<String, dynamic>),
      commerce: Commerce.fromJson(json['commerce'] as Map<String, dynamic>),
      buttons: (json['buttons'] as List<dynamic>?)
          ?.map((e) => Button.fromJson(e as Map<String, dynamic>))
          .toList(),
      buttonTitle: json['button_title'] as String?,
      objectType: json['object_type'] as String? ?? "commerce",
    );

Map<String, dynamic> _$CommerceTemplateToJson(CommerceTemplate instance) =>
    <String, dynamic>{
      'content': instance.content.toJson(),
      'commerce': instance.commerce.toJson(),
      if (instance.buttons?.map((e) => e.toJson()).toList() case final value?)
        'buttons': value,
      if (instance.buttonTitle case final value?) 'button_title': value,
      'object_type': instance.objectType,
    };
