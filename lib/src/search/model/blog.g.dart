// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Blog _$BlogFromJson(Map<String, dynamic> json) {
  return Blog(
    json['title'] as String,
    json['contents'] as String,
    Uri.parse(json['url'] as String),
    DateTime.parse(json['datetime'] as String),
    Uri.parse(json['thumbnail'] as String),
    json['blogname'] as String,
  );
}

Map<String, dynamic> _$BlogToJson(Blog instance) => <String, dynamic>{
      'title': instance.title,
      'contents': instance.contents,
      'url': instance.url.toString(),
      'datetime': instance.datetime.toIso8601String(),
      'thumbnail': instance.thumbnail.toString(),
      'blogname': instance.blogName,
    };
