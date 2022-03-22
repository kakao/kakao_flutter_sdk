import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_user/src/model/app_service_terms.dart';
import 'package:kakao_flutter_sdk_user/src/model/service_terms.dart';

part 'user_service_terms.g.dart';

/// 사용자가 동의한 약관 조회 API 응답 클래스
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class UserServiceTerms {
  /// 회원번호
  int? userId;

  /// 사용자가 동의한 3rd의 약관 항목들
  List<ServiceTerms>? allowedServiceTerms;
  List<AppServiceTerms>? appServiceTerms;

  /// @nodoc
  UserServiceTerms(this.userId, this.allowedServiceTerms);

  /// @nodoc
  factory UserServiceTerms.fromJson(Map<String, dynamic> json) =>
      _$UserServiceTermsFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$UserServiceTermsToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
