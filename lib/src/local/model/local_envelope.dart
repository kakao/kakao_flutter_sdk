import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/local/generics_converter.dart';

part 'local_envelope.g.dart';

@JsonSerializable()
class LocalEnvelope<T, U> {
  @GenericsConverter()
  T meta;
  @GenericsConverter()
  List<U> documents;

  LocalEnvelope(this.meta, this.documents);

  /// <nodoc>
  factory LocalEnvelope.fromJson(Map<String, dynamic> json) =>
      _$LocalEnvelopeFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$LocalEnvelopeToJson(this);

  @override
  String toString() => toJson().toString();
}
