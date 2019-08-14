// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendsResponse _$FriendsResponseFromJson(Map<String, dynamic> json) {
  return FriendsResponse(
    (json['elements'] as List)
        ?.map((e) =>
            e == null ? null : Friend.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['total_count'] as int,
    json['before_url'] == null ? null : Uri.parse(json['before_url'] as String),
    json['after_url'] == null ? null : Uri.parse(json['after_url'] as String),
  );
}

Map<String, dynamic> _$FriendsResponseToJson(FriendsResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('elements', instance.friends?.map((e) => e?.toJson())?.toList());
  writeNotNull('total_count', instance.totalCount);
  writeNotNull('before_url', instance.beforeUrl?.toString());
  writeNotNull('after_url', instance.afterUrl?.toString());
  return val;
}
