// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commerce_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommerceTemplate _$CommerceTemplateFromJson(Map<String, dynamic> json) {
  return CommerceTemplate(
    content: Content.fromJson(json['content'] as Map<String, dynamic>),
    commerce: Commerce.fromJson(json['commerce'] as Map<String, dynamic>),
    buttons: (json['buttons'] as List<dynamic>?)
        ?.map((e) => Button.fromJson(e as Map<String, dynamic>))
        .toList(),
    buttonTitle: json['button_title'] as String?,
    objectType: json['object_type'] as String,
  );
}

Map<String, dynamic> _$CommerceTemplateToJson(CommerceTemplate instance) {
  final val = <String, dynamic>{
    'content': instance.content.toJson(),
    'commerce': instance.commerce.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('buttons', instance.buttons?.map((e) => e.toJson()).toList());
  writeNotNull('button_title', instance.buttonTitle);
  val['object_type'] = instance.objectType;
  return val;
}
