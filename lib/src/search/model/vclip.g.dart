// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vclip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VClip _$VClipFromJson(Map<String, dynamic> json) {
  return VClip(
    json['title'] as String,
    Uri.parse(json['url'] as String),
    DateTime.parse(json['datetime'] as String),
    json['play_time'] as int,
    Uri.parse(json['thumbnail'] as String),
    json['author'] as String,
  );
}

Map<String, dynamic> _$VClipToJson(VClip instance) => <String, dynamic>{
      'title': instance.title,
      'url': instance.url.toString(),
      'datetime': instance.datetime.toIso8601String(),
      'play_time': instance.playTime,
      'thumbnail': instance.thumbnail.toString(),
      'author': instance.author,
    };
