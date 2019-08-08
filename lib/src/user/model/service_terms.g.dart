// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_terms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceTerms _$ServiceTermsFromJson(Map<String, dynamic> json) {
  return ServiceTerms(
    json['user_id'] as int,
    (json['allowed_service_terms'] as List)
        ?.map(
            (e) => e == null ? null : Terms.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ServiceTermsToJson(ServiceTerms instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('user_id', instance.userId);
  writeNotNull('allowed_service_terms',
      instance.allowedServiceTerms?.map((e) => e?.toJson())?.toList());
  return val;
}
