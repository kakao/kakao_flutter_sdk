// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationTemplate _$LocationTemplateFromJson(Map<String, dynamic> json) =>
    LocationTemplate(
      address: json['address'] as String,
      content: Content.fromJson(json['content'] as Map<String, dynamic>),
      addressTitle: json['address_title'] as String?,
      social: json['social'] == null
          ? null
          : Social.fromJson(json['social'] as Map<String, dynamic>),
      buttons: (json['buttons'] as List<dynamic>?)
          ?.map((e) => Button.fromJson(e as Map<String, dynamic>))
          .toList(),
      buttonTitle: json['button_title'] as String?,
      objectType: json['object_type'] as String? ?? "location",
    );

Map<String, dynamic> _$LocationTemplateToJson(LocationTemplate instance) =>
    <String, dynamic>{
      'address': instance.address,
      'content': instance.content.toJson(),
      if (instance.addressTitle case final value?) 'address_title': value,
      if (instance.social?.toJson() case final value?) 'social': value,
      if (instance.buttons?.map((e) => e.toJson()).toList() case final value?)
        'buttons': value,
      if (instance.buttonTitle case final value?) 'button_title': value,
      'object_type': instance.objectType,
    };
