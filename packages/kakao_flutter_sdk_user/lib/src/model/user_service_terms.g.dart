// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_service_terms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserServiceTerms _$UserServiceTermsFromJson(Map<String, dynamic> json) =>
    UserServiceTerms(
      (json['id'] as num).toInt(),
      (json['service_terms'] as List<dynamic>?)
          ?.map((e) => ServiceTerms.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserServiceTermsToJson(UserServiceTerms instance) =>
    <String, dynamic>{
      'id': instance.id,
      if (instance.serviceTerms?.map((e) => e.toJson()).toList()
          case final value?)
        'service_terms': value,
    };
