// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_revoked_service_terms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRevokedServiceTerms _$UserRevokedServiceTermsFromJson(
        Map<String, dynamic> json) =>
    UserRevokedServiceTerms(
      (json['id'] as num).toInt(),
      (json['revoked_service_terms'] as List<dynamic>?)
          ?.map((e) => RevokedServiceTerms.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserRevokedServiceTermsToJson(
        UserRevokedServiceTerms instance) =>
    <String, dynamic>{
      'id': instance.id,
      if (instance.revokedServiceTerms?.map((e) => e.toJson()).toList()
          case final value?)
        'revoked_service_terms': value,
    };
