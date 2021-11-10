import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/template/default_template.dart';
import 'package:kakao_flutter_sdk/src/template/model/button.dart';
import 'package:kakao_flutter_sdk/src/template/model/commerce.dart';
import 'package:kakao_flutter_sdk/src/template/model/content.dart';

part 'commerce_template.g.dart';

/// Default template for commerce type.
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class CommerceTemplate extends DefaultTemplate {
  final Content content;
  final Commerce commerce;
  final List<Button>? buttons;
  final String? buttonTitle;

  final String objectType;

  /// <nodoc>
  CommerceTemplate(this.content, this.commerce,
      {this.buttons, this.buttonTitle, this.objectType = "commerce"});

  /// <nodoc>
  factory CommerceTemplate.fromJson(Map<String, dynamic> json) =>
      _$CommerceTemplateFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$CommerceTemplateToJson(this);
}
