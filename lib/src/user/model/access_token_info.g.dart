// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_token_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessTokenInfo _$AccessTokenInfoFromJson(Map<String, dynamic> json) {
  return AccessTokenInfo(
    json['app_id'] as int,
    json['id'] as int,
    json['expires_in'] as int,
    json['expiresInMillis'] as int?,
  );
}

Map<String, dynamic> _$AccessTokenInfoToJson(AccessTokenInfo instance) {
  final val = <String, dynamic>{
    'app_id': instance.appId,
    'id': instance.id,
    'expires_in': instance.expiresIn,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('expiresInMillis', instance.expiresInMillis);
  return val;
}
