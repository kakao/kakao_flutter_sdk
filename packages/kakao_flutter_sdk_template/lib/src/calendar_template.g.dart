// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarTemplate _$CalendarTemplateFromJson(Map<String, dynamic> json) =>
    CalendarTemplate(
      id: json['id'] as String,
      idType: $enumDecode(_$IdTypeEnumMap, json['id_type']),
      content: Content.fromJson(json['content'] as Map<String, dynamic>),
      buttons: (json['buttons'] as List<dynamic>?)
          ?.map((e) => Button.fromJson(e as Map<String, dynamic>))
          .toList(),
      objectType: json['object_type'] as String? ?? "calendar",
    );

Map<String, dynamic> _$CalendarTemplateToJson(CalendarTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_type': _$IdTypeEnumMap[instance.idType]!,
      'content': instance.content.toJson(),
      if (instance.buttons?.map((e) => e.toJson()).toList() case final value?)
        'buttons': value,
      'object_type': instance.objectType,
    };

const _$IdTypeEnumMap = {
  IdType.calendar: 'calendar',
  IdType.event: 'event',
};
