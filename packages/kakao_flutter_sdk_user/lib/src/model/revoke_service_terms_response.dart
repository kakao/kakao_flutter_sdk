import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_user/src/model/service_terms.dart';

part 'revoke_service_terms_response.g.dart';

/// 사용자가 동의한 약관 조회 API 응답 클래스
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class RevokeServiceTermsResponse {
  int id;

  List<ServiceTerms>? revokedServiceTerms;

  /// @nodoc
  RevokeServiceTermsResponse(this.id, this.revokedServiceTerms);

  /// @nodoc
  factory RevokeServiceTermsResponse.fromJson(Map<String, dynamic> json) =>
      _$RevokeServiceTermsResponseFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$RevokeServiceTermsResponseToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
