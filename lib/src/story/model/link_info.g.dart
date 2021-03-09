// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinkInfo _$LinkInfoFromJson(Map<String, dynamic> json) {
  return LinkInfo(
    Uri.parse(json['url'] as String),
    Uri.parse(json['requested_url'] as String),
    json['host'] as String,
    json['title'] as String,
    (json['image'] as List<dynamic>).map((e) => e as String).toList(),
    json['description'] as String,
    json['section'] as String,
    json['type'] as String,
  );
}

Map<String, dynamic> _$LinkInfoToJson(LinkInfo instance) => <String, dynamic>{
      'url': instance.url.toString(),
      'requested_url': instance.requestedUrl.toString(),
      'host': instance.host,
      'title': instance.title,
      'image': instance.images,
      'description': instance.description,
      'section': instance.section,
      'type': instance.type,
    };
