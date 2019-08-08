// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_token_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessTokenInfo _$AccessTokenInfoFromJson(Map<String, dynamic> json) {
  return AccessTokenInfo(
    json['appId'] as int,
    json['id'] as int,
    json['expiresInMillis'] as int,
  );
}

Map<String, dynamic> _$AccessTokenInfoToJson(AccessTokenInfo instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('appId', instance.appId);
  writeNotNull('id', instance.id);
  writeNotNull('expiresInMillis', instance.expiresInMillis);
  return val;
}
