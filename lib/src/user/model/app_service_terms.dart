import 'package:json_annotation/json_annotation.dart';

part 'app_service_terms.g.dart';

/// Individual terms.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AppServiceTerms {
  String tag;
  DateTime createdAt;
  DateTime updatedAt;

  /// <nodoc>
  AppServiceTerms(this.tag, this.createdAt, this.updatedAt);

  /// <nodoc>
  factory AppServiceTerms.fromJson(Map<String, dynamic> json) =>
      _$AppServiceTermsFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$AppServiceTermsToJson(this);
}
