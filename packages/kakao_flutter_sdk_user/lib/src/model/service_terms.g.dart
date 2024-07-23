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

Map<String, dynamic> _$ServiceTermsToJson(ServiceTerms instance) {
  final val = <String, dynamic>{
    'tag': instance.tag,
    'required': instance.required,
    'agreed': instance.agreed,
    'revocable': instance.revocable,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('agreed_at', instance.agreedAt?.toIso8601String());
  writeNotNull('agreed_by', _$RefererEnumMap[instance.referer]);
  return val;
}

const _$RefererEnumMap = {
  Referer.kauth: 'KAUTH',
  Referer.kapi: 'KAPI',
  Referer.unknown: 'unknown',
};
