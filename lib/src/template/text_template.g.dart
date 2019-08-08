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
    objectType: json['object_type'] as String,
  );
}

Map<String, dynamic> _$TextTemplateToJson(TextTemplate instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('text', instance.text);
  writeNotNull('link', instance.link?.toJson());
  writeNotNull('button_title', instance.buttonTitle);
  writeNotNull('buttons', instance.buttons?.map((e) => e?.toJson())?.toList());
  writeNotNull('object_type', instance.objectType);
  return val;
}
