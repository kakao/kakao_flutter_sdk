import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_user/src/model/service_terms.dart';

part 'user_service_terms.g.dart';

/// KO: 서비스 약관 동의 내역 확인하기 응답
/// <br>
/// EN: Response for Retrieve consent details for service terms
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class UserServiceTerms {
  /// KO: 회원번호
  /// <br>
  /// EN: Service user ID
  int id;

  /// KO: 서비스 약관 목록
  /// <br>
  /// EN: List of service terms
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
