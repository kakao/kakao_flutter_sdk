// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oauth_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OAuthToken _$OAuthTokenFromJson(Map<String, dynamic> json) => OAuthToken(
      json['access_token'] as String,
      DateTime.parse(json['expires_at'] as String),
      json['refresh_token'] as String?,
      json['refresh_token_expires_at'] == null
          ? null
          : DateTime.parse(json['refresh_token_expires_at'] as String),
      (json['scopes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      idToken: json['id_token'] as String?,
    );

Map<String, dynamic> _$OAuthTokenToJson(OAuthToken instance) {
  final val = <String, dynamic>{
    'access_token': instance.accessToken,
    'expires_at': instance.expiresAt.toIso8601String(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('refresh_token', instance.refreshToken);
  writeNotNull('refresh_token_expires_at',
      instance.refreshTokenExpiresAt?.toIso8601String());
  writeNotNull('scopes', instance.scopes);
  writeNotNull('id_token', instance.idToken);
  return val;
}
