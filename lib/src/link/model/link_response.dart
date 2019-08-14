import 'package:json_annotation/json_annotation.dart';

part 'link_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class LinkResponse {
  /// <nodoc>
  LinkResponse(this.templateId, this.templateArgs, this.templateMsg,
      this.warningMsg, this.argumentMsg);
  int templateId;
  Map<String, dynamic> templateArgs;
  Map<String, dynamic> templateMsg;
  Map<String, dynamic> warningMsg;
  Map<String, dynamic> argumentMsg;

  @override
  String toString() {
    return toJson().toString();
  }

  /// <nodoc>
  factory LinkResponse.fromJson(Map<String, dynamic> json) =>
      _$LinkResponseFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$LinkResponseToJson(this);
}
