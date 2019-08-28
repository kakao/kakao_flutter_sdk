// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tip _$TipFromJson(Map<String, dynamic> json) {
  return Tip(
    json['title'] as String,
    json['contents'] as String,
    json['datetime'] == null
        ? null
        : DateTime.parse(json['datetime'] as String),
    json['q_url'] == null ? null : Uri.parse(json['q_url'] as String),
    json['a_url'] == null ? null : Uri.parse(json['a_url'] as String),
    (json['thumbnails'] as List)
        ?.map((e) => e == null ? null : Uri.parse(e as String))
        ?.toList(),
    json['type'] as String,
  );
}

Map<String, dynamic> _$TipToJson(Tip instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('title', instance.title);
  writeNotNull('contents', instance.contents);
  writeNotNull('q_url', instance.questionUrl?.toString());
  writeNotNull('a_url', instance.answerUrl?.toString());
  writeNotNull(
      'thumbnails', instance.thumbnails?.map((e) => e?.toString())?.toList());
  writeNotNull('type', instance.type);
  writeNotNull('datetime', instance.datetime?.toIso8601String());
  return val;
}
