// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Terms _$TermsFromJson(Map<String, dynamic> json) {
  return Terms(json['tag'] as String, json['agreed_at'] as String);
}

Map<String, dynamic> _$TermsToJson(Terms instance) =>
    <String, dynamic>{'tag': instance.tag, 'agreed_at': instance.agreedAt};
