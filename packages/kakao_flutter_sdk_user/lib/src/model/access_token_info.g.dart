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

Map<String, dynamic> _$AccessTokenInfoToJson(AccessTokenInfo instance) {
  final val = <String, dynamic>{
    'app_id': instance.appId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['expires_in'] = instance.expiresIn;
  return val;
}
