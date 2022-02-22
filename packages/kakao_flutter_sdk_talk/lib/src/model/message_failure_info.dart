import 'package:json_annotation/json_annotation.dart';

part 'message_failure_info.g.dart';

/// 여러 친구를 대상으로 메시지 전송 API 호출 시 대상 중 일부가 실패한 경우 오류 정보
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MessageFailureInfo {
  /// 오류 코드
  final int code;
  final String msg;

  /// 이 에러로 인해 실패한 대상 목록
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
