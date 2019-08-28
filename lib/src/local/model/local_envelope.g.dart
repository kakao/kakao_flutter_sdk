// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_envelope.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalEnvelope<T, U> _$LocalEnvelopeFromJson<T, U>(Map<String, dynamic> json) {
  return LocalEnvelope<T, U>(
    GenericsConverter<T>().fromJson(json['meta']),
    (json['documents'] as List)?.map(GenericsConverter<U>().fromJson)?.toList(),
  );
}

Map<String, dynamic> _$LocalEnvelopeToJson<T, U>(
        LocalEnvelope<T, U> instance) =>
    <String, dynamic>{
      'meta': GenericsConverter<T>().toJson(instance.meta),
      'documents':
          instance.documents?.map(GenericsConverter<U>().toJson)?.toList(),
    };
