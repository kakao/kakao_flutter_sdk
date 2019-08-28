// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_envelope.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchEnvelope<T> _$SearchEnvelopeFromJson<T>(Map<String, dynamic> json) {
  return SearchEnvelope<T>(
    json['meta'] == null
        ? null
        : SearchMeta.fromJson(json['meta'] as Map<String, dynamic>),
    (json['documents'] as List)?.map(GenericsConverter<T>().fromJson)?.toList(),
  );
}

Map<String, dynamic> _$SearchEnvelopeToJson<T>(SearchEnvelope<T> instance) =>
    <String, dynamic>{
      'meta': instance.meta,
      'documents':
          instance.documents?.map(GenericsConverter<T>().toJson)?.toList(),
    };
