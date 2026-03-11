// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Social _$SocialFromJson(Map<String, dynamic> json) => Social(
  likeCount: (json['like_count'] as num?)?.toInt(),
  commentCount: (json['comment_count'] as num?)?.toInt(),
  sharedCount: (json['shared_count'] as num?)?.toInt(),
  viewCount: (json['view_count'] as num?)?.toInt(),
  subscriberCount: (json['subscriber_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$SocialToJson(Social instance) => <String, dynamic>{
  'like_count': ?instance.likeCount,
  'comment_count': ?instance.commentCount,
  'shared_count': ?instance.sharedCount,
  'view_count': ?instance.viewCount,
  'subscriber_count': ?instance.subscriberCount,
};
