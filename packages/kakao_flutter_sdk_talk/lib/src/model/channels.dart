import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_talk/src/model/channel.dart';

part 'channels.g.dart';

/// KO: 카카오톡 채널 관계 목록
/// <br>
/// EN: List of the Kakao Talk Channel relationship
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class Channels {
  /// KO: 회원번호
  /// <br>
  /// EN: Service user ID
  int? userId;

  /// KO: 카카오톡 채널 관계 목록
  /// <br>
  /// EN: List of the Kakao Talk Channel relationship
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
