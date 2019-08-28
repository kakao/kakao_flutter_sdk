// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebResult _$WebResultFromJson(Map<String, dynamic> json) {
  return WebResult(
    json['title'] as String,
    json['contents'] as String,
    json['url'] == null ? null : Uri.parse(json['url'] as String),
    json['datetime'] == null
        ? null
        : DateTime.parse(json['datetime'] as String),
  );
}

Map<String, dynamic> _$WebResultToJson(WebResult instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('title', instance.title);
  writeNotNull('contents', instance.contents);
  writeNotNull('url', instance.url?.toString());
  writeNotNull('datetime', instance.datetime?.toIso8601String());
  return val;
}
