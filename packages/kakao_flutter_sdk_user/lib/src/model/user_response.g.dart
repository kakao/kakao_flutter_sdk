// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
      (json['id'] as num).toInt(),
      json['has_signed_up'] as bool?,
      (json['properties'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      json['kakao_account'] == null
          ? null
          : Account.fromJson(json['kakao_account'] as Map<String, dynamic>),
      json['group_user_token'] as String?,
      json['synched_at'] == null
          ? null
          : DateTime.parse(json['synched_at'] as String),
      json['connected_at'] == null
          ? null
          : DateTime.parse(json['connected_at'] as String),
      json['for_partner'] == null
          ? null
          : ForPartner.fromJson(json['for_partner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) {
  final val = <String, dynamic>{
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('properties', instance.properties);
  writeNotNull('kakao_account', instance.kakaoAccount?.toJson());
  writeNotNull('group_user_token', instance.groupUserToken);
  writeNotNull('connected_at', instance.connectedAt?.toIso8601String());
  writeNotNull('synched_at', instance.synchedAt?.toIso8601String());
  writeNotNull('has_signed_up', instance.hasSignedUp);
  writeNotNull('for_partner', instance.forPartner?.toJson());
  return val;
}

ForPartner _$ForPartnerFromJson(Map<String, dynamic> json) => ForPartner(
      json['uuid'] as String?,
    );

Map<String, dynamic> _$ForPartnerToJson(ForPartner instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('uuid', instance.uuid);
  return val;
}
