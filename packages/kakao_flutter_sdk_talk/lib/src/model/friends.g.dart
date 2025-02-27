// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friends _$FriendsFromJson(Map<String, dynamic> json) => Friends(
      (json['elements'] as List<dynamic>?)
          ?.map((e) => Friend.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['total_count'] as num).toInt(),
      (json['favorite_count'] as num?)?.toInt(),
      json['before_url'] as String?,
      json['after_url'] as String?,
    );

Map<String, dynamic> _$FriendsToJson(Friends instance) => <String, dynamic>{
      if (instance.elements?.map((e) => e.toJson()).toList() case final value?)
        'elements': value,
      'total_count': instance.totalCount,
      if (instance.favoriteCount case final value?) 'favorite_count': value,
      if (instance.beforeUrl case final value?) 'before_url': value,
      if (instance.afterUrl case final value?) 'after_url': value,
    };
