import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/template/default_template.dart';
import 'package:kakao_flutter_sdk/src/template/model/button.dart';
import 'package:kakao_flutter_sdk/src/template/model/link.dart';

part 'text_template.g.dart';

/// Default template for text type.
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class TextTemplate extends DefaultTemplate {
  /// <nodoc>
  TextTemplate(this.text, this.link,
      {this.buttonTitle, this.buttons, this.objectType = "text"});

  final String text;
  final Link link;
  final String buttonTitle;
  final List<Button> buttons;

  final String objectType;

  /// <nodoc>
  factory TextTemplate.fromJson(Map<String, dynamic> json) =>
      _$TextTemplateFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$TextTemplateToJson(this);
}
