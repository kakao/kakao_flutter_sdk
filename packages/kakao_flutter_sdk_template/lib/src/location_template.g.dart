// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationTemplate _$LocationTemplateFromJson(Map<String, dynamic> json) {
  return LocationTemplate(
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
    objectType: json['object_type'] as String,
  );
}

Map<String, dynamic> _$LocationTemplateToJson(LocationTemplate instance) {
  final val = <String, dynamic>{
    'address': instance.address,
    'content': instance.content.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('address_title', instance.addressTitle);
  writeNotNull('social', instance.social?.toJson());
  writeNotNull('buttons', instance.buttons?.map((e) => e.toJson()).toList());
  writeNotNull('button_title', instance.buttonTitle);
  val['object_type'] = instance.objectType;
  return val;
}
