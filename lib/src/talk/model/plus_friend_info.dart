import 'package:json_annotation/json_annotation.dart';
part 'plus_friend_info.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PlusFriendInfo {
  PlusFriendInfo(this.uuid, this.publicId, this.relation, this.updatedAt);
  @JsonKey(name: "plus_friend_uuid")
  String uuid;
  @JsonKey(name: "plus_friend_public_id")
  String publicId;
  String relation;
  String updatedAt;

  factory PlusFriendInfo.fromJson(Map<String, dynamic> json) =>
      _$PlusFriendInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PlusFriendInfoToJson(this);
}
