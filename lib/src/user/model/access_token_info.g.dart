// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_token_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessTokenInfo _$AccessTokenInfoFromJson(Map<String, dynamic> json) {
  return AccessTokenInfo(
      json['appId'] as int, json['id'] as int, json['expiresInMillis'] as int);
}

Map<String, dynamic> _$AccessTokenInfoToJson(AccessTokenInfo instance) =>
    <String, dynamic>{
      'appId': instance.appId,
      'id': instance.id,
      'expiresInMillis': instance.expiresInMillis
    };
