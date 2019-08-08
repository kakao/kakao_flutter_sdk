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
    json['token_type'] as String,
  );
}

Map<String, dynamic> _$AccessTokenResponseToJson(AccessTokenResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('access_token', instance.accessToken);
  writeNotNull('expires_in', instance.expiresIn);
  writeNotNull('refresh_token', instance.refreshToken);
  writeNotNull('refresh_token_expires_in', instance.refreshTokenExpiresIn);
  writeNotNull('scope', instance.scopes);
  writeNotNull('token_type', instance.tokenType);
  return val;
}
