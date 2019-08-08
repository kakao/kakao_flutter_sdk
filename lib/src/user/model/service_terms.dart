import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/user/model/terms.dart';

export 'terms.dart';

part 'service_terms.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class ServiceTerms {
  ServiceTerms(this.userId, this.allowedServiceTerms);

  int userId;
  List<Terms> allowedServiceTerms;

  factory ServiceTerms.fromJson(Map<String, dynamic> json) =>
      _$ServiceTermsFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceTermsToJson(this);
}
