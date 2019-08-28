// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vclip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VClip _$VClipFromJson(Map<String, dynamic> json) {
  return VClip(
    json['title'] as String,
    json['url'] == null ? null : Uri.parse(json['url'] as String),
    json['datetime'] == null
        ? null
        : DateTime.parse(json['datetime'] as String),
    json['play_time'] as int,
    json['thumbnail'] == null ? null : Uri.parse(json['thumbnail'] as String),
    json['author'] as String,
  );
}

Map<String, dynamic> _$VClipToJson(VClip instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('title', instance.title);
  writeNotNull('url', instance.url?.toString());
  writeNotNull('datetime', instance.datetime?.toIso8601String());
  writeNotNull('play_time', instance.playTime);
  writeNotNull('thumbnail', instance.thumbnail?.toString());
  writeNotNull('author', instance.author);
  return val;
}
