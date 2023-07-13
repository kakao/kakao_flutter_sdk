import 'package:json_annotation/json_annotation.dart';

part 'revoked_service_terms.g.dart';

/// 동의 철회가 반영된 서비스 약관 클래스
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class RevokedServiceTerms {
  /// 3rd 에서 설정한 서비스 약관의 tag
  String tag;

  /// 동의 여부
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
