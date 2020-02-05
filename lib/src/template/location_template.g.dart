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
    objectType: json['object_type'] as String,
  );
}

Map<String, dynamic> _$LocationTemplateToJson(LocationTemplate instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('address', instance.address);
  writeNotNull('content', instance.content?.toJson());
  writeNotNull('address_title', instance.addressTitle);
  writeNotNull('social', instance.social?.toJson());
  writeNotNull('buttons', instance.buttons?.map((e) => e?.toJson())?.toList());
  writeNotNull('object_type', instance.objectType);
  return val;
}
