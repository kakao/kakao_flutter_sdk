// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_service_terms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserServiceTerms _$UserServiceTermsFromJson(Map<String, dynamic> json) =>
    UserServiceTerms(
      json['id'] as int,
      (json['service_terms'] as List<dynamic>?)
          ?.map((e) => ServiceTerms.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserServiceTermsToJson(UserServiceTerms instance) {
  final val = <String, dynamic>{
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'service_terms', instance.serviceTerms?.map((e) => e.toJson()).toList());
  return val;
}
