// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationTemplate _$LocationTemplateFromJson(Map<String, dynamic> json) {
  return LocationTemplate(
    json['address'] as String,
    json['content'] == null
        ? null
        : Content.fromJson(json['content'] as Map<String, dynamic>),
    addressTitle: json['address_title'] as String,
    social: json['social'] == null
        ? null
        : Social.fromJson(json['social'] as Map<String, dynamic>),
    buttons: (json['buttons'] as List)
        ?.map((e) =>
            e == null ? null : Button.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$LocationTemplateToJson(LocationTemplate instance) =>
    <String, dynamic>{
      'address': instance.address,
      'content': instance.content?.toJson(),
      'address_title': instance.addressTitle,
      'social': instance.social?.toJson(),
      'buttons': instance.buttons?.map((e) => e?.toJson())?.toList(),
    };
