import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/template/default_template.dart';
import 'package:kakao_flutter_sdk/src/template/model/button.dart';
import 'package:kakao_flutter_sdk/src/template/model/link.dart';

part 'text_template.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class TextTemplate extends DefaultTemplate {
  TextTemplate(this.text, this.link,
      {this.buttonTitle, this.buttons, this.objectType = "text"});

  final String text;
  final Link link;
  final String buttonTitle;
  final List<Button> buttons;

  final String objectType;

  factory TextTemplate.fromJson(Map<String, dynamic> json) =>
      _$TextTemplateFromJson(json);
  Map<String, dynamic> toJson() => _$TextTemplateToJson(this);
}
