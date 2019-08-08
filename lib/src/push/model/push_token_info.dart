import 'package:json_annotation/json_annotation.dart';

part 'push_token_info.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PushTokenInfo {
  PushTokenInfo(this.userId, this.deviceId, this.pushType, this.pushToken,
      this.createdAt, this.updatedAt);

  final String userId;
  final String deviceId;
  final String pushType;
  final String pushToken;
  final String createdAt;
  final String updatedAt;

  factory PushTokenInfo.fromJson(Map<String, dynamic> json) =>
      _$PushTokenInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PushTokenInfoToJson(this);
}
