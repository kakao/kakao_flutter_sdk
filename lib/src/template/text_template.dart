import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/template/default_template.dart';
import 'package:kakao_flutter_sdk/src/template/model/button.dart';
import 'package:kakao_flutter_sdk/src/template/model/link.dart';

part 'text_template.g.dart';

/// Default template for text type.
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class TextTemplate extends DefaultTemplate {
  final String text;
  final Link link;
  final List<Button>? buttons;
  final String? buttonTitle;

  final String objectType;

  /// <nodoc>
  TextTemplate(this.text, this.link,
      {this.buttons, this.buttonTitle, this.objectType = "text"});

  /// <nodoc>
  factory TextTemplate.fromJson(Map<String, dynamic> json) =>
      _$TextTemplateFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$TextTemplateToJson(this);
}
