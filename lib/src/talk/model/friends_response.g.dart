// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendsResponse _$FriendsResponseFromJson(Map<String, dynamic> json) {
  return FriendsResponse(
    (json['elements'] as List<dynamic>)
        .map((e) => Friend.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['total_count'] as int,
    Uri.parse(json['before_url'] as String),
    Uri.parse(json['after_url'] as String),
  );
}

Map<String, dynamic> _$FriendsResponseToJson(FriendsResponse instance) =>
    <String, dynamic>{
      'elements': instance.friends.map((e) => e.toJson()).toList(),
      'total_count': instance.totalCount,
      'before_url': instance.beforeUrl.toString(),
      'after_url': instance.afterUrl.toString(),
    };
