// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_terms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceTerms _$ServiceTermsFromJson(Map<String, dynamic> json) {
  return ServiceTerms(
    json['tag'] as String,
    DateTime.parse(json['agreed_at'] as String),
  );
}

Map<String, dynamic> _$ServiceTermsToJson(ServiceTerms instance) =>
    <String, dynamic>{
      'tag': instance.tag,
      'agreed_at': instance.agreedAt.toIso8601String(),
    };
