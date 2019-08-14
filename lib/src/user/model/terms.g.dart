// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Terms _$TermsFromJson(Map<String, dynamic> json) {
  return Terms(
    json['tag'] as String,
    json['agreed_at'] == null
        ? null
        : DateTime.parse(json['agreed_at'] as String),
  );
}

Map<String, dynamic> _$TermsToJson(Terms instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('tag', instance.tag);
  writeNotNull('agreed_at', instance.agreedAt?.toIso8601String());
  return val;
}
