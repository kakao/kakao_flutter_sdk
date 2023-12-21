import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_talk/src/constants.dart';

part 'follow_channel_result.g.dart';

/// 카카오톡 간편 채널 추가 결과
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class FollowChannelResult {
  /// 요청 결과
  @StatusConverter()
  @JsonKey(name: 'status')
  final bool success;

  /// 요청한 채널 public Id
  final String channelPublicId;

  /// @nodoc
  FollowChannelResult(this.success, this.channelPublicId);

  /// @nodoc
  factory FollowChannelResult.fromJson(Map<String, dynamic> json) =>
      _$FollowChannelResultFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$FollowChannelResultToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}

/// @nodoc
class StatusConverter implements JsonConverter<bool, String> {
  const StatusConverter();

  @override
  bool fromJson(String status) =>
      status == Constants.followChannelStatusSuccess;

  @override
  String toJson(bool success) => success
      ? Constants.followChannelStatusSuccess
      : Constants.followChannelStatusFail;
}
