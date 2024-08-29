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

Map<String, dynamic> _$SocialToJson(Social instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('like_count', instance.likeCount);
  writeNotNull('comment_count', instance.commentCount);
  writeNotNull('shared_count', instance.sharedCount);
  writeNotNull('view_count', instance.viewCount);
  writeNotNull('subscriber_count', instance.subscriberCount);
  return val;
}
