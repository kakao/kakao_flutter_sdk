import 'package:json_annotation/json_annotation.dart';

part 'channel.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Channel {
  @JsonKey(name: "channel_uuid")
  String uuid;
  @JsonKey(name: "channel_public_id")
  String encodedId;
  String relation;
  DateTime? updatedAt;

  /// <nodoc>
  Channel(this.uuid, this.encodedId, this.relation, this.updatedAt);

  /// <nodoc>
  factory Channel.fromJson(Map<String, dynamic> json) =>
      _$ChannelFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$ChannelToJson(this);
}
