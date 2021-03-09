// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListTemplate _$ListTemplateFromJson(Map<String, dynamic> json) {
  return ListTemplate(
    json['header_title'] as String,
    Link.fromJson(json['header_link'] as Map<String, dynamic>),
    contents: (json['contents'] as List<dynamic>?)
        ?.map((e) => Content.fromJson(e as Map<String, dynamic>))
        .toList(),
    buttons: (json['buttons'] as List<dynamic>?)
        ?.map((e) => Button.fromJson(e as Map<String, dynamic>))
        .toList(),
    objectType: json['object_type'] as String,
  );
}

Map<String, dynamic> _$ListTemplateToJson(ListTemplate instance) {
  final val = <String, dynamic>{
    'header_title': instance.headerTitle,
    'header_link': instance.headerLink.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('contents', instance.contents?.map((e) => e.toJson()).toList());
  writeNotNull('buttons', instance.buttons?.map((e) => e.toJson()).toList());
  val['object_type'] = instance.objectType;
  return val;
}
