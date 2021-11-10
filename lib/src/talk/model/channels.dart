import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/talk/model/channel.dart';

part 'channels.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class Channels {
  int? userId;
  List<Channel>? channels;

  /// <nodoc>
  Channels(this.userId, this.channels);

  /// <nodoc>
  factory Channels.fromJson(Map<String, dynamic> json) =>
      _$ChannelsFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$ChannelsToJson(this);
}
