import 'package:json_annotation/json_annotation.dart';

part 'revoked_service_terms.g.dart';

/// 사용자가 동의한 약관 조회 API 응답 클래스
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class RevokedServiceTerms {
  /// 동의한 약관의 tag. 3rd 에서 설정한 값
  String tag;

  bool agreed;

  /// @nodoc
  RevokedServiceTerms(this.tag, this.agreed);

  /// @nodoc
  factory RevokedServiceTerms.fromJson(Map<String, dynamic> json) =>
      _$RevokedServiceTermsFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$RevokedServiceTermsToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
