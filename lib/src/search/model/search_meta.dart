import 'package:json_annotation/json_annotation.dart';

part 'search_meta.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SearchMeta {
  /// total number of documents
  int totalCount;

  ///
  int pageableCount;

  /// Whether current page is the end page. Next request can be made with an incremented page number if this flag is false.
  bool isEnd;

  SearchMeta(this.totalCount, this.pageableCount, this.isEnd);

  /// <nodoc>
  factory SearchMeta.fromJson(Map<String, dynamic> json) =>
      _$SearchMetaFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$SearchMetaToJson(this);

  @override
  String toString() => toJson().toString();
}
