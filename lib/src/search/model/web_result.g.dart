// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebResult _$WebResultFromJson(Map<String, dynamic> json) {
  return WebResult(
    json['title'] as String,
    json['contents'] as String,
    Uri.parse(json['url'] as String),
    DateTime.parse(json['datetime'] as String),
  );
}

Map<String, dynamic> _$WebResultToJson(WebResult instance) => <String, dynamic>{
      'title': instance.title,
      'contents': instance.contents,
      'url': instance.url.toString(),
      'datetime': instance.datetime.toIso8601String(),
    };
