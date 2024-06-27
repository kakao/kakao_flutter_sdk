import 'package:json_annotation/json_annotation.dart';

part 'channel.g.dart';

/// KO: 카카오톡 채널 관계
/// <br>
/// EN: Relationship with the Kakao Talk Channel
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Channel {
  /// KO: 카카오톡 채널 고유 ID
  /// <br>
  /// EN: Kakao Talk Channel unique ID
  @JsonKey(name: "channel_uuid")
  String uuid;

  /// KO: 카카오톡 채널 프로필 ID
  /// <br>
  /// EN: Kakao Talk Channel profile ID
  @JsonKey(name: "channel_public_id")
  String encodedId;

  /// KO: 카카오톡 채널 관계
  /// <br>
  /// EN: Relationship with the Kakao Talk Channel
  String relation;

  /// KO: 최종 변경 일시
  /// <br>
  /// EN: Last update time
  DateTime? updatedAt;

  /// @nodoc
  Channel(this.uuid, this.encodedId, this.relation, this.updatedAt);

  /// @nodoc
  factory Channel.fromJson(Map<String, dynamic> json) =>
      _$ChannelFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$ChannelToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
