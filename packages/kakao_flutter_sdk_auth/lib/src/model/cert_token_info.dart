import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_auth/src/model/oauth_token.dart';

part 'cert_token_info.g.dart';

/// KO: 토큰 정보와 전자서명 접수번호
/// <br>
/// EN: Token information and transaction ID
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class CertTokenInfo {
  /// KO: 토큰 정보
  /// <br>
  /// EN: Token information
  OAuthToken token;

  /// KO: 전자서명 접수번호
  /// <br>
  /// EN: Transaction ID
  String txId;

  /// @nodoc
  CertTokenInfo(this.token, this.txId);

  /// @nodoc
  factory CertTokenInfo.fromJson(Map<String, dynamic> json) =>
      _$CertTokenInfoFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$CertTokenInfoToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
