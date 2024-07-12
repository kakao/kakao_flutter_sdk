import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_user/src/model/revoked_service_terms.dart';

part 'user_revoked_service_terms.g.dart';

/// KO: 서비스 약관 동의 철회하기 응답
/// <br>
/// EN: Response for Revoke consent for service terms
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class UserRevokedServiceTerms {
  /// KO: 회원번호
  /// <br>
  /// EN: Service user ID
  int id;

  /// KO: 동의 철회에 성공한 서비스 약관 목록
  /// <br>
  /// EN: List of revoked service terms
  List<RevokedServiceTerms>? revokedServiceTerms;

  /// @nodoc
  UserRevokedServiceTerms(this.id, this.revokedServiceTerms);

  /// @nodoc
  factory UserRevokedServiceTerms.fromJson(Map<String, dynamic> json) =>
      _$UserRevokedServiceTermsFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$UserRevokedServiceTermsToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
