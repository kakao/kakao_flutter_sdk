import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/user/model/app_service_terms.dart';
import 'package:kakao_flutter_sdk/src/user/model/service_terms.dart';

part 'user_service_terms.g.dart';

/// Response from [UserApi.serviceTerms()]
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class UserServiceTerms {
  int? userId;
  List<ServiceTerms>? allowedServiceTerms;
  List<AppServiceTerms>? appServiceTerms;

  /// <nodoc>
  UserServiceTerms(this.userId, this.allowedServiceTerms);

  /// <nodoc>
  factory UserServiceTerms.fromJson(Map<String, dynamic> json) =>
      _$UserServiceTermsFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$UserServiceTermsToJson(this);
}
