// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_actor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryActor _$StoryActorFromJson(Map<String, dynamic> json) {
  return StoryActor(
    json['display_name'] as String,
    Uri.parse(json['profile_thumbnail_url'] as String),
  );
}

Map<String, dynamic> _$StoryActorToJson(StoryActor instance) =>
    <String, dynamic>{
      'display_name': instance.displayName,
      'profile_thumbnail_url': instance.profileThumbnailUrl.toString(),
    };
