import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/auth/model/oauth_token.dart';

part 'cert_token_info.g.dart';

/// API response from https://kauth.kakao.com/oauth/token API
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class CertTokenInfo {
  OAuthToken token;
  String txId;

  /// <nodoc>
  CertTokenInfo(this.token, this.txId);

  /// <nodoc>
  factory CertTokenInfo.fromJson(Map<String, dynamic> json) =>
      _$CertTokenInfoFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$CertTokenInfoToJson(this);
}
