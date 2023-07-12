import 'package:json_annotation/json_annotation.dart';

part 'service_terms.g.dart';

/// 3rd party 서비스 약관 정보 클래스
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ServiceTerms {
  /// 3rd 에서 설정한 서비스 약관의 tag
  String tag;

  /// 필수 동의 여부
  bool required;

  /// 동의 여부
  bool agreed;

  /// 철회 가능 여부
  bool revocable;

  /// 최근 동의 시각
  DateTime? agreedAt;

  /// @nodoc
  ServiceTerms(
      this.tag, this.required, this.agreed, this.revocable, this.agreedAt);

  /// @nodoc
  factory ServiceTerms.fromJson(Map<String, dynamic> json) =>
      _$ServiceTermsFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$ServiceTermsToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
