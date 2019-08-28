import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/search/generics_converter.dart';
import 'package:kakao_flutter_sdk/src/search/model/search_meta.dart';

part 'search_envelope.g.dart';

@JsonSerializable()
class SearchEnvelope<T> {
  SearchMeta meta;
  @GenericsConverter()
  List<T> documents;

  SearchEnvelope(this.meta, this.documents);

  /// <nodoc>
  factory SearchEnvelope.fromJson(Map<String, dynamic> json) =>
      _$SearchEnvelopeFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$SearchEnvelopeToJson(this);

  @override
  String toString() => toJson().toString();
}
