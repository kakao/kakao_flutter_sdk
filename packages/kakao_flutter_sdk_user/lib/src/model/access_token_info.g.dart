// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_token_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessTokenInfo _$AccessTokenInfoFromJson(Map<String, dynamic> json) =>
    AccessTokenInfo(
      (json['app_id'] as num).toInt(),
      (json['id'] as num?)?.toInt(),
      (json['expires_in'] as num).toInt(),
    );

Map<String, dynamic> _$AccessTokenInfoToJson(AccessTokenInfo instance) =>
    <String, dynamic>{
      'app_id': instance.appId,
      if (instance.id case final value?) 'id': value,
      'expires_in': instance.expiresIn,
    };
