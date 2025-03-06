// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListTemplate _$ListTemplateFromJson(Map<String, dynamic> json) => ListTemplate(
      headerTitle: json['header_title'] as String,
      headerLink: Link.fromJson(json['header_link'] as Map<String, dynamic>),
      contents: (json['contents'] as List<dynamic>)
          .map((e) => Content.fromJson(e as Map<String, dynamic>))
          .toList(),
      buttons: (json['buttons'] as List<dynamic>?)
          ?.map((e) => Button.fromJson(e as Map<String, dynamic>))
          .toList(),
      buttonTitle: json['button_title'] as String?,
      objectType: json['object_type'] as String? ?? "list",
    );

Map<String, dynamic> _$ListTemplateToJson(ListTemplate instance) =>
    <String, dynamic>{
      'header_title': instance.headerTitle,
      'header_link': instance.headerLink.toJson(),
      'contents': instance.contents.map((e) => e.toJson()).toList(),
      if (instance.buttons?.map((e) => e.toJson()).toList() case final value?)
        'buttons': value,
      if (instance.buttonTitle case final value?) 'button_title': value,
      'object_type': instance.objectType,
    };
