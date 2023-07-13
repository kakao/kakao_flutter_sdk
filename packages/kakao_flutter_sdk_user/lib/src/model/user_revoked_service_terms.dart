import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_user/src/model/revoked_service_terms.dart';
import 'package:kakao_flutter_sdk_user/src/model/service_terms.dart';

part 'user_revoked_service_terms.g.dart';

/// 서비스 약관 철회 API 응답 클래스
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class UserRevokedServiceTerms {
  /// 회원번호
  int id;

  /// 동의 철회가 반영된 서비스 약관 목록
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
