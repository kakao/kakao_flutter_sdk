// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cert_token_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CertTokenInfo _$CertTokenInfoFromJson(Map<String, dynamic> json) {
  return CertTokenInfo(
    OAuthToken.fromJson(json['token'] as Map<String, dynamic>),
    json['tx_id'] as String,
  );
}

Map<String, dynamic> _$CertTokenInfoToJson(CertTokenInfo instance) =>
    <String, dynamic>{
      'token': instance.token,
      'tx_id': instance.txId,
    };
