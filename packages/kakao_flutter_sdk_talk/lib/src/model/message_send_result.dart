import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_talk/src/model/message_failure_info.dart';

part 'message_send_result.g.dart';

/// 메시지 전송 API 호출 결과
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class MessageSendResult {
  /// 메시지 전송에 성공한 대상의 uuid
  final List<String>? successfulReceiverUuids;

  /// (복수의 전송 대상을 지정한 경우) 전송 실패한 일부 대상의 오류 정보
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
