// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['id'] as int,
    json['has_signed_up'] as bool,
    (json['properties'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    json['kakao_account'] == null
        ? null
        : Account.fromJson(json['kakao_account'] as Map<String, dynamic>),
    json['group_user_token'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('has_signed_up', instance.hasSignedUp);
  writeNotNull('properties', instance.properties);
  writeNotNull('kakao_account', instance.kakaoAccount?.toJson());
  writeNotNull('group_user_token', instance.groupUserToken);
  return val;
}
