// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(json['has_signed_up'] as bool)
    ..id = json['id'] as int
    ..properties = (json['properties'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    )
    ..kakaoAccount = json['kakao_account'] == null
        ? null
        : Account.fromJson(json['kakao_account'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'has_signed_up': instance.hasSignedUp,
      'properties': instance.properties,
      'kakao_account': instance.kakaoAccount?.toJson()
    };
