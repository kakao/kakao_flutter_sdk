// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Social _$SocialFromJson(Map<String, dynamic> json) {
  return Social(
    likeCount: json['like_count'] as int,
    commentCount: json['comment_count'] as int,
    sharedCount: json['shared_count'] as int,
    viewCount: json['view_count'] as int,
    subscriberCount: json['subscriber_count'] as int,
  );
}

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
