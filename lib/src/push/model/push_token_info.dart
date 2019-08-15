import 'package:json_annotation/json_annotation.dart';

part 'push_token_info.g.dart';

/// Push token this user has registered before.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PushTokenInfo {
  /// <nodoc>
  PushTokenInfo(this.userId, this.deviceId, this.pushType, this.pushToken,
      this.createdAt, this.updatedAt);

  final String userId;
  final String deviceId;
  @JsonKey(unknownEnumValue: PushType.UNKNOWN)
  final PushType pushType;
  final String pushToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// <nodoc>
  factory PushTokenInfo.fromJson(Map<String, dynamic> json) =>
      _$PushTokenInfoFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$PushTokenInfoToJson(this);
}

enum PushType {
  @JsonValue("gcm")
  GCM,
  @JsonValue("apns")
  APNS,
  UNKNOWN
}
