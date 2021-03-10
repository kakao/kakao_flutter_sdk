// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['id'] as int,
    json['has_signed_up'] as bool?,
    Map<String, String>.from(json['properties'] as Map),
    Account.fromJson(json['kakao_account'] as Map<String, dynamic>),
    json['group_user_token'] as String,
    DateTime.parse(json['synched_at'] as String),
    DateTime.parse(json['connected_at'] as String),
  );
}

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('has_signed_up', instance.hasSignedUp);
  val['properties'] = instance.properties;
  val['kakao_account'] = instance.kakaoAccount.toJson();
  val['group_user_token'] = instance.groupUserToken;
  val['synched_at'] = instance.synchedAt.toIso8601String();
  val['connected_at'] = instance.connectedAt.toIso8601String();
  return val;
}
