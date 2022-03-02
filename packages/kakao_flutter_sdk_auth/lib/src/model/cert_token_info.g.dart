// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cert_token_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CertTokenInfo _$CertTokenInfoFromJson(Map<String, dynamic> json) {
  return CertTokenInfo(
    OAuthToken.fromJson(json['token'] as Map<String, dynamic>),
    json['tx_id'] as String,
    idToken: json['id_token'] as String?,
  );
}

Map<String, dynamic> _$CertTokenInfoToJson(CertTokenInfo instance) {
  final val = <String, dynamic>{
    'token': instance.token,
    'tx_id': instance.txId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id_token', instance.idToken);
  return val;
}
