// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) {
  return Account(
      json['has_email'] as bool,
      json['is_email_verified'] as bool,
      json['email'] as String,
      json['is_kakaotalk_user'] as bool,
      json['has_phone_number'] as bool,
      json['phone_number'] as String);
}

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'has_email': instance.hasEmail,
      'is_email_verified': instance.isEmailVerified,
      'email': instance.email,
      'is_kakaotalk_user': instance.isKakaotalkUser,
      'has_phone_number': instance.hasPhoneNumber,
      'phone_number': instance.phoneNumber
    };
