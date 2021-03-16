// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tip _$TipFromJson(Map<String, dynamic> json) {
  return Tip(
    json['title'] as String,
    json['contents'] as String,
    DateTime.parse(json['datetime'] as String),
    Uri.parse(json['q_url'] as String),
    Uri.parse(json['a_url'] as String),
    (json['thumbnails'] as List<dynamic>)
        .map((e) => Uri.parse(e as String))
        .toList(),
    json['type'] as String,
  );
}

Map<String, dynamic> _$TipToJson(Tip instance) => <String, dynamic>{
      'title': instance.title,
      'contents': instance.contents,
      'q_url': instance.questionUrl.toString(),
      'a_url': instance.answerUrl.toString(),
      'thumbnails': instance.thumbnails.map((e) => e.toString()).toList(),
      'type': instance.type,
      'datetime': instance.datetime.toIso8601String(),
    };
