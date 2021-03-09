// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_envelope.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchEnvelope<T> _$SearchEnvelopeFromJson<T>(Map<String, dynamic> json) {
  return SearchEnvelope<T>(
    SearchMeta.fromJson(json['meta'] as Map<String, dynamic>),
    (json['documents'] as List<dynamic>)
        .map((e) => GenericsConverter<T>().fromJson(e as Object))
        .toList(),
  );
}

Map<String, dynamic> _$SearchEnvelopeToJson<T>(SearchEnvelope<T> instance) =>
    <String, dynamic>{
      'meta': instance.meta,
      'documents':
          instance.documents.map(GenericsConverter<T>().toJson).toList(),
    };
