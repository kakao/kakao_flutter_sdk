import 'package:json_annotation/json_annotation.dart';

part 'access_token_info.g.dart';

/// 토큰 정보 요청 API 응답 클래스
@JsonSerializable(includeIfNull: false)
class AccessTokenInfo {
  /// 해당 access token이 발급된 앱 ID
  @JsonKey(name: 'app_id')
  int appId;

  /// 회원번호
  int? id;

  /// 해당 access token의 남은 만료시간 (단위: 초)
  @JsonKey(name: "expires_in")
  int expiresIn;

  /// @nodoc
  AccessTokenInfo(this.appId, this.id, this.expiresIn);

  /// @nodoc
  factory AccessTokenInfo.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenInfoFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$AccessTokenInfoToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
