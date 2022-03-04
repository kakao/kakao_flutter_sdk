// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinkInfo _$LinkInfoFromJson(Map<String, dynamic> json) {
  return LinkInfo(
    json['url'] as String?,
    json['requested_url'] as String?,
    json['host'] as String?,
    json['title'] as String?,
    (json['image'] as List<dynamic>?)?.map((e) => e as String).toList(),
    json['description'] as String?,
    json['section'] as String?,
    json['type'] as String?,
  );
}

Map<String, dynamic> _$LinkInfoToJson(LinkInfo instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('url', instance.url);
  writeNotNull('requested_url', instance.requestedUrl);
  writeNotNull('host', instance.host);
  writeNotNull('title', instance.title);
  writeNotNull('image', instance.images);
  writeNotNull('description', instance.description);
  writeNotNull('section', instance.section);
  writeNotNull('type', instance.type);
  return val;
}
