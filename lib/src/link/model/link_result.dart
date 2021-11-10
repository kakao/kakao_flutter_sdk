import 'package:json_annotation/json_annotation.dart';

part 'link_result.g.dart';

/// Response from kakaoLink validation API.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class LinkResult {
  int templateId;
  Map<String, dynamic>? templateArgs;
  Map<String, dynamic> templateMsg;

  // Warnings against template and arguments validation
  Map<String, dynamic> warningMsg;
  Map<String, dynamic> argumentMsg;

  /// <nodoc>
  LinkResult(this.templateId, this.templateArgs, this.templateMsg,
      this.warningMsg, this.argumentMsg);

  /// <nodoc>
  factory LinkResult.fromJson(Map<String, dynamic> json) =>
      _$LinkResultFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$LinkResultToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
