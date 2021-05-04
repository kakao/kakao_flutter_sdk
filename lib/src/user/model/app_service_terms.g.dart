// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_service_terms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppServiceTerms _$AppServiceTermsFromJson(Map<String, dynamic> json) {
  return AppServiceTerms(
    json['tag'] as String,
    DateTime.parse(json['created_at'] as String),
    DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$AppServiceTermsToJson(AppServiceTerms instance) =>
    <String, dynamic>{
      'tag': instance.tag,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
