import 'package:json_annotation/json_annotation.dart';

part 'message_failure_info.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MessageFailureInfo {
  final int code;
  final String msg;
  final List<String> receiverUuids;

  /// <nodoc>
  MessageFailureInfo(this.code, this.msg, this.receiverUuids);

  /// <nodoc>
  factory MessageFailureInfo.fromJson(Map<String, dynamic> json) =>
      _$MessageFailureInfoFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$MessageFailureInfoToJson(this);
}
