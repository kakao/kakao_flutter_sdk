import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/template/default_template.dart';
import 'package:kakao_flutter_sdk/src/template/model/button.dart';
import 'package:kakao_flutter_sdk/src/template/model/content.dart';
import 'package:kakao_flutter_sdk/src/template/model/link.dart';

part 'list_template.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ListTemplate extends DefaultTemplate {
  ListTemplate(this.headerTitle, this.headerLink,
      {this.contents, this.buttons, this.objectType = "list"});

  final String headerTitle;
  final Link headerLink;
  final List<Content> contents;
  final List<Button> buttons;

  final String objectType;

  factory ListTemplate.fromJson(Map<String, dynamic> json) =>
      _$ListTemplateFromJson(json);
  Map<String, dynamic> toJson() => _$ListTemplateToJson(this);
}
