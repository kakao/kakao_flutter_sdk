import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_talk/src/constants.dart';

part 'follow_channel_result.g.dart';

/// KO: 카카오톡 채널 간편 추가 결과
/// <br>
/// EN: Result of Follow Kakao Talk Channel
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class FollowChannelResult {
  /// KO: 성공 여부
  /// <br>
  /// EN: Success status
  @StatusConverter()
  @JsonKey(name: 'status')
  final bool success;

  /// KO: 카카오톡 채널 프로필 ID
  /// <br>
  /// EN: Kakao Talk Channel profile ID
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
