import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_user/src/model/service_terms.dart';

part 'user_service_terms.g.dart';

/// 사용자가 동의한 약관 조회 API 응답 클래스
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class UserServiceTerms {
  /// 회원번호
  int id;

  List<ServiceTerms>? serviceTerms;

  /// @nodoc
  UserServiceTerms(this.id, this.serviceTerms);

  /// @nodoc
  factory UserServiceTerms.fromJson(Map<String, dynamic> json) =>
      _$UserServiceTermsFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$UserServiceTermsToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
