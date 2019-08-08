import 'package:json_annotation/json_annotation.dart';

part 'terms.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Terms {
  Terms(this.tag, this.agreedAt);
  String tag;
  String agreedAt;

  factory Terms.fromJson(Map<String, dynamic> json) => _$TermsFromJson(json);
  Map<String, dynamic> toJson() => _$TermsToJson(this);
}
