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
      if (instance.likeCount case final value?) 'like_count': value,
      if (instance.commentCount case final value?) 'comment_count': value,
      if (instance.sharedCount case final value?) 'shared_count': value,
      if (instance.viewCount case final value?) 'view_count': value,
      if (instance.subscriberCount case final value?) 'subscriber_count': value,
    };
