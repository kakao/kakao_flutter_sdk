import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/user/model/terms.dart';

part 'service_terms.g.dart';

/// Response from [UserApi.serviceTerms()]
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class ServiceTerms {
  /// <nodoc>
  ServiceTerms(this.userId, this.allowedServiceTerms);

  int userId;
  List<Terms> allowedServiceTerms;

  /// <nodoc>
  factory ServiceTerms.fromJson(Map<String, dynamic> json) =>
      _$ServiceTermsFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$ServiceTermsToJson(this);
}
