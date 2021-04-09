import 'package:json_annotation/json_annotation.dart';

part 'service_terms.g.dart';

/// Individual terms.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ServiceTerms {
  String tag;
  DateTime agreedAt;

  /// <nodoc>
  ServiceTerms(this.tag, this.agreedAt);

  /// <nodoc>
  factory ServiceTerms.fromJson(Map<String, dynamic> json) =>
      _$ServiceTermsFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$ServiceTermsToJson(this);
}
