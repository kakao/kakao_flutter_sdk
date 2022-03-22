import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_auth/src/model/oauth_token.dart';
import 'package:kakao_flutter_sdk_auth/src/token_manager.dart';

part 'cert_token_info.g.dart';

/// 카카오톡 인증 로그인을 통해 발급 받은 토큰 및 전자서명 접수번호
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class CertTokenInfo {
  /// 토큰 정보, 발급된 토큰은 [TokenManagerProvider]에 지정된 토큰 저장소에 자동 저장
  OAuthToken token;

  /// txId 전자서명 접수번호
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
