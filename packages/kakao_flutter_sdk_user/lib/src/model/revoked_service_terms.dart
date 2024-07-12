import 'package:json_annotation/json_annotation.dart';

part 'revoked_service_terms.g.dart';

/// KO: 동의 철회된 서비스 약관 정보
/// <br>
/// EN: Revoked service terms information
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class RevokedServiceTerms {
  /// KO: 태그
  /// <br>
  /// EN: Tag
  String tag;

  /// KO: 동의 여부
  /// <br>
  /// EN: The consent status of the service terms
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
