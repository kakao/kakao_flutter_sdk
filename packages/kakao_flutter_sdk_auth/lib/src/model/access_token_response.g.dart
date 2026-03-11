// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessTokenResponse _$AccessTokenResponseFromJson(Map<String, dynamic> json) =>
    AccessTokenResponse(
      json['access_token'] as String,
      (json['expires_in'] as num).toInt(),
      json['refresh_token'] as String?,
      (json['refresh_token_expires_in'] as num?)?.toInt(),
      json['scope'] as String?,
      json['token_type'] as String,
      idToken: json['id_token'] as String?,
    );

Map<String, dynamic> _$AccessTokenResponseToJson(
  AccessTokenResponse instance,
) => <String, dynamic>{
  'access_token': instance.accessToken,
  'expires_in': instance.expiresIn,
  'refresh_token': ?instance.refreshToken,
  'refresh_token_expires_in': ?instance.refreshTokenExpiresIn,
  'scope': ?instance.scope,
  'token_type': instance.tokenType,
  'id_token': ?instance.idToken,
};
