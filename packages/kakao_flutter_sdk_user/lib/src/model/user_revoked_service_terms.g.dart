// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_revoked_service_terms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRevokedServiceTerms _$UserRevokedServiceTermsFromJson(
        Map<String, dynamic> json) =>
    UserRevokedServiceTerms(
      json['id'] as int,
      (json['revoked_service_terms'] as List<dynamic>?)
          ?.map((e) => RevokedServiceTerms.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserRevokedServiceTermsToJson(
    UserRevokedServiceTerms instance) {
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
