import 'package:json_annotation/json_annotation.dart';

part 'service_terms.g.dart';

/// 3rd party 서비스 약관 정보 클래스
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ServiceTerms {
  /// 동의한 약관의 tag. 3rd 에서 설정한 값
  String tag;

  /// 동의한 시간
  /// 약관이 여러번 뜨는 구조라면, 마지막으로 동의한 시간
  DateTime agreedAt;

  /// @nodoc
  ServiceTerms(this.tag, this.agreedAt);

  /// @nodoc
  factory ServiceTerms.fromJson(Map<String, dynamic> json) =>
      _$ServiceTermsFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$ServiceTermsToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
