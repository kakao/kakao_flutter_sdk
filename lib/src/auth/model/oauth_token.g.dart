// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oauth_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OAuthToken _$OAuthTokenFromJson(Map<String, dynamic> json) {
  return OAuthToken(
    json['access_token'] as String?,
    json['access_token_expires_at'] == null
        ? null
        : DateTime.parse(json['access_token_expires_at'] as String),
    json['refresh_token'] as String?,
    json['refresh_token_expires_at'] == null
        ? null
        : DateTime.parse(json['refresh_token_expires_at'] as String),
    (json['scopes'] as List<dynamic>?)?.map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$OAuthTokenToJson(OAuthToken instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('access_token', instance.accessToken);
  writeNotNull('access_token_expires_at',
      instance.accessTokenExpiresAt?.toIso8601String());
  writeNotNull('refresh_token', instance.refreshToken);
  writeNotNull('refresh_token_expires_at',
      instance.refreshTokenExpiresAt?.toIso8601String());
  writeNotNull('scopes', instance.scopes);
  return val;
}
