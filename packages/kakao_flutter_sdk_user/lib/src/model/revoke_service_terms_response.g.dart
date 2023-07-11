// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revoke_service_terms_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RevokeServiceTermsResponse _$RevokeServiceTermsResponseFromJson(
        Map<String, dynamic> json) =>
    RevokeServiceTermsResponse(
      json['id'] as int,
      (json['revoked_service_terms'] as List<dynamic>?)
          ?.map((e) => ServiceTerms.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RevokeServiceTermsResponseToJson(
    RevokeServiceTermsResponse instance) {
  final val = <String, dynamic>{
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('revoked_service_terms',
      instance.revokedServiceTerms?.map((e) => e.toJson()).toList());
  return val;
}
