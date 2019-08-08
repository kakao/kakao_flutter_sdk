// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListTemplate _$ListTemplateFromJson(Map<String, dynamic> json) {
  return ListTemplate(
    json['header_title'] as String,
    json['header_link'] == null
        ? null
        : Link.fromJson(json['header_link'] as Map<String, dynamic>),
    contents: (json['contents'] as List)
        ?.map((e) =>
            e == null ? null : Content.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    buttons: (json['buttons'] as List)
        ?.map((e) =>
            e == null ? null : Button.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    objectType: json['object_type'] as String,
  );
}

Map<String, dynamic> _$ListTemplateToJson(ListTemplate instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('header_title', instance.headerTitle);
  writeNotNull('header_link', instance.headerLink?.toJson());
  writeNotNull(
      'contents', instance.contents?.map((e) => e?.toJson())?.toList());
  writeNotNull('buttons', instance.buttons?.map((e) => e?.toJson())?.toList());
  writeNotNull('object_type', instance.objectType);
  return val;
}
