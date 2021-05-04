import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/talk/model/channel_relation.dart';

part 'channel_relations.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class ChannelRelations {
  int? userId;
  @JsonKey(name: "plus_friends")
  List<ChannelRelation> channels;

  /// <nodoc>
  ChannelRelations(this.userId, this.channels);

  /// <nodoc>
  factory ChannelRelations.fromJson(Map<String, dynamic> json) =>
      _$ChannelRelationsFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$ChannelRelationsToJson(this);
}
