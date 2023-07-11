// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_terms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceTerms _$ServiceTermsFromJson(Map<String, dynamic> json) => ServiceTerms(
      json['tag'] as String,
      json['required'] as bool?,
      json['agreed'] as bool,
      json['revocable'] as bool?,
      json['agreed_at'] == null
          ? null
          : DateTime.parse(json['agreed_at'] as String),
    );

Map<String, dynamic> _$ServiceTermsToJson(ServiceTerms instance) {
  final val = <String, dynamic>{
    'tag': instance.tag,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('required', instance.required);
  val['agreed'] = instance.agreed;
  writeNotNull('revocable', instance.revocable);
  writeNotNull('agreed_at', instance.agreedAt?.toIso8601String());
  return val;
}
