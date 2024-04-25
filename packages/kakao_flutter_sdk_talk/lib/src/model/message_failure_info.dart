import 'package:json_annotation/json_annotation.dart';

part 'message_failure_info.g.dart';

/// KO: 메시지 전송 실패 정보
/// <br>
/// EN: Failure information for sending a message
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MessageFailureInfo {
  /// KO: 에러 코드
  /// <br>
  /// EN: Error code
  final int code;

  /// KO: 에러 메시지
  /// <br>
  /// EN: Error message
  final String msg;

  /// KO: 메시지 전송에 실패한 수신자 UUID 목록
  /// <br>
  /// EN: Receiver UUIDs that failed to send the message
  final List<String> receiverUuids;

  /// @nodoc
  MessageFailureInfo(this.code, this.msg, this.receiverUuids);

  /// @nodoc
  factory MessageFailureInfo.fromJson(Map<String, dynamic> json) =>
      _$MessageFailureInfoFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$MessageFailureInfoToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
