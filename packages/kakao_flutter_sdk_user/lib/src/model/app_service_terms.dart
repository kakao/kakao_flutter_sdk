import 'package:json_annotation/json_annotation.dart';

part 'app_service_terms.g.dart';

/// 앱에 사용 설정된 서비스 약관 목록 클래스
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AppServiceTerms {
  /// 서비스 약관에 설정된 태그(tag)
  String tag;

  /// 서비스 약관이 등록된 시간
  DateTime createdAt;

  /// 서비스 약관이 수정된 시간
  DateTime updatedAt;

  /// @nodoc
  AppServiceTerms(this.tag, this.createdAt, this.updatedAt);

  /// @nodoc
  factory AppServiceTerms.fromJson(Map<String, dynamic> json) =>
      _$AppServiceTermsFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$AppServiceTermsToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
