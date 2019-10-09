import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/talk/model/message_failure_info.dart';

part 'message_send_result.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class MessageSendResult {
  final List<String> successfulReceiverUuids;
  @JsonKey(name: "failure_info")
  final List<MessageFailureInfo> failureInfos;

  /// <nodoc>
  MessageSendResult(this.successfulReceiverUuids, this.failureInfos);

  /// <nodoc>
  factory MessageSendResult.fromJson(Map<String, dynamic> json) =>
      _$MessageSendResultFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$MessageSendResultToJson(this);
}
