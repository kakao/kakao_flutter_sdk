import 'package:json_annotation/json_annotation.dart';

part 'count_meta.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class CountMeta {
  final int totalCount;

  CountMeta(this.totalCount);

  /// <nodoc>
  factory CountMeta.fromJson(Map<String, dynamic> json) =>
      _$CountMetaFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$CountMetaToJson(this);

  @override
  String toString() => toJson().toString();
}
