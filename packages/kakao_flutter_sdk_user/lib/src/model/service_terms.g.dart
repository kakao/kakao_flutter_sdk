// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_terms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceTerms _$ServiceTermsFromJson(Map<String, dynamic> json) => ServiceTerms(
      json['tag'] as String,
      json['required'] as bool,
      json['agreed'] as bool,
      json['revocable'] as bool,
      json['agreed_at'] == null
          ? null
          : DateTime.parse(json['agreed_at'] as String),
      $enumDecodeNullable(_$RefererEnumMap, json['agreed_by'],
          unknownValue: Referer.unknown),
    );

Map<String, dynamic> _$ServiceTermsToJson(ServiceTerms instance) =>
    <String, dynamic>{
      'tag': instance.tag,
      'required': instance.required,
      'agreed': instance.agreed,
      'revocable': instance.revocable,
      if (instance.agreedAt?.toIso8601String() case final value?)
        'agreed_at': value,
      if (_$RefererEnumMap[instance.referer] case final value?)
        'agreed_by': value,
    };

const _$RefererEnumMap = {
  Referer.kauth: 'KAUTH',
  Referer.kapi: 'KAPI',
  Referer.unknown: 'unknown',
};
