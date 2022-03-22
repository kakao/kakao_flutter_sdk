// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oauth_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OAuthToken _$OAuthTokenFromJson(Map<String, dynamic> json) {
  return OAuthToken(
    json['access_token'] as String,
    DateTime.parse(json['access_token_expires_at'] as String),
    DateTime.parse(json['expires_at'] as String),
    json['refresh_token'] as String,
    DateTime.parse(json['refresh_token_expires_at'] as String),
    (json['scopes'] as List<dynamic>?)?.map((e) => e as String).toList(),
    idToken: json['id_token'] as String?,
  );
}

Map<String, dynamic> _$OAuthTokenToJson(OAuthToken instance) {
  final val = <String, dynamic>{
    'access_token': instance.accessToken,
    'access_token_expires_at': instance.accessTokenExpiresAt.toIso8601String(),
    'expires_at': instance.expiresAt.toIso8601String(),
    'refresh_token': instance.refreshToken,
    'refresh_token_expires_at':
        instance.refreshTokenExpiresAt.toIso8601String(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('scopes', instance.scopes);
  writeNotNull('id_token', instance.idToken);
  return val;
}
