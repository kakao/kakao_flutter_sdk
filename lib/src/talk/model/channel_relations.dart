import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/talk/model/channel_relation.dart';

part 'channel_relations.g.dart';

/// 카카오톡 채널 추가상태 조회 API 응답 클래스
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class ChannelRelations {
  /// 사용자 아이디
  int? userId;

  /// 사용자의 채널 추가상태 목록
  List<ChannelRelation> channels;

  /// @nodoc
  ChannelRelations(this.userId, this.channels);

  /// @nodoc
  factory ChannelRelations.fromJson(Map<String, dynamic> json) =>
      _$ChannelRelationsFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$ChannelRelationsToJson(this);
}
