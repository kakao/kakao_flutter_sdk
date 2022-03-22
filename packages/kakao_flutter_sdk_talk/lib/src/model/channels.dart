import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_talk/src/model/channel.dart';

part 'channels.g.dart';

/// 카카오톡 채널 추가상태 조회 API 응답 클래스
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class Channels {
  /// 회원번호
  int? userId;

  /// 사용자의 채널 추가상태 목록
  List<Channel>? channels;

  /// @nodoc
  Channels(this.userId, this.channels);

  /// @nodoc
  factory Channels.fromJson(Map<String, dynamic> json) =>
      _$ChannelsFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$ChannelsToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
