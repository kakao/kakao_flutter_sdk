// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessTokenResponse _$AccessTokenResponseFromJson(Map<String, dynamic> json) {
  return AccessTokenResponse(
      json['access_token'] as String,
      json['expires_in'] as int,
      json['refresh_token'] as String,
      json['refresh_token_expires_in'] as int,
      json['scope'] as String,
      json['token_type'] as String);
}

Map<String, dynamic> _$AccessTokenResponseToJson(
        AccessTokenResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'expires_in': instance.expiresIn,
      'refresh_token': instance.refreshToken,
      'refresh_token_expires_in': instance.refreshTokenExpiresIn,
      'scope': instance.scopes,
      'token_type': instance.tokenType
    };
