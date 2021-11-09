import 'package:json_annotation/json_annotation.dart';

part 'channel_relation.g.dart';

/// 카카오톡 채널 추가상태 정보.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ChannelRelation {
  /// 채널의 uuid
  @JsonKey(name: "channel_uuid")
  String uuid;

  /// encoded channel public id (ex. https://pf.kakao.com/${channelId})
  @JsonKey(name: "channel_public_id")
  String publicId;

  /// 사용자의 채널 추가 상태
  String relation;

  /// 마지막 상태 변경 일시 (현재는 ADDED 상태의 친구 추가시각만 의미)
  DateTime? updatedAt;

  /// @nodoc
  ChannelRelation(this.uuid, this.publicId, this.relation, this.updatedAt);

  /// @nodoc
  factory ChannelRelation.fromJson(Map<String, dynamic> json) =>
      _$ChannelRelationFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$ChannelRelationToJson(this);
}
