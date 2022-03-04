// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_actor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryActor _$StoryActorFromJson(Map<String, dynamic> json) {
  return StoryActor(
    json['display_name'] as String,
    json['profile_thumbnail_url'] as String?,
  );
}

Map<String, dynamic> _$StoryActorToJson(StoryActor instance) {
  final val = <String, dynamic>{
    'display_name': instance.displayName,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('profile_thumbnail_url', instance.profileThumbnailUrl);
  return val;
}
