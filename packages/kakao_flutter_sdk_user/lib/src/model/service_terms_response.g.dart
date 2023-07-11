// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_terms_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceTermsResponse _$ServiceTermsResponseFromJson(
        Map<String, dynamic> json) =>
    ServiceTermsResponse(
      json['id'] as int,
      (json['service_terms'] as List<dynamic>?)
          ?.map((e) => ServiceTerms.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ServiceTermsResponseToJson(
    ServiceTermsResponse instance) {
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
