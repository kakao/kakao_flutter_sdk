// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextTemplate _$TextTemplateFromJson(Map<String, dynamic> json) {
  return TextTemplate(
    text: json['text'] as String,
    link: Link.fromJson(json['link'] as Map<String, dynamic>),
    buttons: (json['buttons'] as List<dynamic>?)
        ?.map((e) => Button.fromJson(e as Map<String, dynamic>))
        .toList(),
    buttonTitle: json['button_title'] as String?,
    objectType: json['object_type'] as String,
  );
}

Map<String, dynamic> _$TextTemplateToJson(TextTemplate instance) {
  final val = <String, dynamic>{
    'text': instance.text,
    'link': instance.link.toJson(),
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
