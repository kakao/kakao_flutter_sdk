// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedTemplate _$FeedTemplateFromJson(Map<String, dynamic> json) {
  return FeedTemplate(
    json['content'] == null
        ? null
        : Content.fromJson(json['content'] as Map<String, dynamic>),
    social: json['social'] == null
        ? null
        : Social.fromJson(json['social'] as Map<String, dynamic>),
    buttons: (json['buttons'] as List)
        ?.map((e) =>
            e == null ? null : Button.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    objectType: json['object_type'] as String,
  );
}

Map<String, dynamic> _$FeedTemplateToJson(FeedTemplate instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('content', instance.content?.toJson());
  writeNotNull('social', instance.social?.toJson());
  writeNotNull('buttons', instance.buttons?.map((e) => e?.toJson())?.toList());
  writeNotNull('object_type', instance.objectType);
  return val;
}
