import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_template/src/default_template.dart';
import 'package:kakao_flutter_sdk_template/src/model/button.dart';
import 'package:kakao_flutter_sdk_template/src/model/link.dart';

part 'text_template.g.dart';

/// KO: 텍스트 메시지용 기본 템플릿
/// <br>
/// EN: Default template for text messages
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class TextTemplate extends DefaultTemplate {
  /// KO: 텍스트
  /// <br>
  /// EN: Text
  final String text;

  /// KO: 바로가기 정보
  /// <br>
  /// EN: Link information
  final Link link;

  /// KO: 메시지 하단 버튼
  /// <br>
  /// EN: Button at the bottom of the message
  final List<Button>? buttons;

  /// KO: 버튼 문구
  /// <br>
  /// EN: Label for the button
  final String? buttonTitle;

  /// KO: 메시지 템플릿 타입, "text"로 고정
  /// <br>
  /// EN: Type of the message template, fixed as "text"
  final String objectType;

  /// @nodoc
  TextTemplate({
    required this.text,
    required this.link,
    this.buttons,
    this.buttonTitle,
    this.objectType = "text",
  });

  /// @nodoc
  factory TextTemplate.fromJson(Map<String, dynamic> json) =>
      _$TextTemplateFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$TextTemplateToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
