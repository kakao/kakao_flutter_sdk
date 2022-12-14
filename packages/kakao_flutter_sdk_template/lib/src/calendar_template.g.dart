// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarTemplate _$CalendarTemplateFromJson(Map<String, dynamic> json) =>
    CalendarTemplate(
      idType: $enumDecode(_$IdTypeEnumMap, json['id_type']),
      id: json['id'] as String,
      content: Content.fromJson(json['content'] as Map<String, dynamic>),
      buttons: (json['buttons'] as List<dynamic>?)
          ?.map((e) => Button.fromJson(e as Map<String, dynamic>))
          .toList(),
      objectType: json['object_type'] as String? ?? "calendar",
    );

Map<String, dynamic> _$CalendarTemplateToJson(CalendarTemplate instance) {
  final val = <String, dynamic>{
    'id_type': _$IdTypeEnumMap[instance.idType]!,
    'id': instance.id,
    'content': instance.content.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('buttons', instance.buttons?.map((e) => e.toJson()).toList());
  val['object_type'] = instance.objectType;
  return val;
}

const _$IdTypeEnumMap = {
  IdType.calendar: 'calendar',
  IdType.event: 'event',
};
