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

Map<String, dynamic> _$CalendarTemplateToJson(CalendarTemplate instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'id_type': _$IdTypeEnumMap[instance.idType]!,
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
