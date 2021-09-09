import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/template/default_template.dart';
import 'package:kakao_flutter_sdk/src/template/model/button.dart';
import 'package:kakao_flutter_sdk/src/template/model/content.dart';
import 'package:kakao_flutter_sdk/src/template/model/link.dart';

part 'list_template.g.dart';

/// Default template for list type.
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class ListTemplate extends DefaultTemplate {
  /// <nodoc>
  ListTemplate(this.headerTitle, this.headerLink, this.contents,
      {this.buttons, this.buttonTitle, this.objectType = "list"});

  final String headerTitle;
  final Link headerLink;
  final List<Content> contents;
  final List<Button>? buttons;
  final String? buttonTitle;

  final String objectType;

  /// <nodoc>
  factory ListTemplate.fromJson(Map<String, dynamic> json) =>
      _$ListTemplateFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$ListTemplateToJson(this);
}
