import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/template/default_template.dart';
import 'package:kakao_flutter_sdk/src/template/model/button.dart';
import 'package:kakao_flutter_sdk/src/template/model/content.dart';
import 'package:kakao_flutter_sdk/src/template/model/social.dart';

part 'location_template.g.dart';

/// Default template for location type.
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class LocationTemplate extends DefaultTemplate {
  /// <nodoc>
  LocationTemplate(this.address, this.content,
      {this.addressTitle,
      this.social,
      this.buttons,
      this.buttonTitle,
      this.objectType = "location"});

  final String address;
  final Content content;
  final String? addressTitle;
  final Social? social;
  final List<Button>? buttons;
  final String? buttonTitle;

  final String objectType;

  /// <nodoc>
  factory LocationTemplate.fromJson(Map<String, dynamic> json) =>
      _$LocationTemplateFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$LocationTemplateToJson(this);
}
