import 'package:json_annotation/json_annotation.dart';

part 'channel_relation.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ChannelRelation {
  @JsonKey(name: "channel_uuid")
  String uuid;
  @JsonKey(name: "channel_public_id")
  String publicId;
  String relation;
  DateTime? updatedAt;

  /// <nodoc>
  ChannelRelation(this.uuid, this.publicId, this.relation, this.updatedAt);

  /// <nodoc>
  factory ChannelRelation.fromJson(Map<String, dynamic> json) =>
      _$ChannelRelationFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$ChannelRelationToJson(this);
}
