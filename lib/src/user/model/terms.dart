import 'package:json_annotation/json_annotation.dart';

part 'terms.g.dart';

/// Individual terms.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Terms {
  /// <nodoc>
  Terms(this.tag, this.agreedAt);
  String tag;
  DateTime agreedAt;

  /// <nodoc>
  factory Terms.fromJson(Map<String, dynamic> json) => _$TermsFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$TermsToJson(this);
}
