import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_talk/src/model/message_failure_info.dart';

part 'message_send_result.g.dart';

/// KO: 메시지 전송 결과
/// <br>
/// EN: Sending message result
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class MessageSendResult {
  /// KO: 메시지 전송에 성공한 수신자 UUID 목록
  /// <br>
  /// EN: Receiver UUIDs that succeeded to send the message
  final List<String>? successfulReceiverUuids;

  /// KO: 메시지 전송 실패 정보
  /// <br>
  /// EN: Failure information for sending a message
  @JsonKey(name: "failure_info")
  final List<MessageFailureInfo>? failureInfos;

  /// @nodoc
  MessageSendResult(this.successfulReceiverUuids, this.failureInfos);

  /// @nodoc
  factory MessageSendResult.fromJson(Map<String, dynamic> json) =>
      _$MessageSendResultFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$MessageSendResultToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
