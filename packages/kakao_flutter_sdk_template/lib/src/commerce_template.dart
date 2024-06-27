import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_template/src/default_template.dart';
import 'package:kakao_flutter_sdk_template/src/model/button.dart';
import 'package:kakao_flutter_sdk_template/src/model/commerce.dart';
import 'package:kakao_flutter_sdk_template/src/model/content.dart';

part 'commerce_template.g.dart';

/// KO: 커머스 메시지용 기본 템플릿
/// <br>
/// EN: Default template for commerce messages
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class CommerceTemplate extends DefaultTemplate {
  /// KO: 메시지 콘텐츠
  /// <br>
  /// EN: Contents for the message
  final Content content;

  /// KO: 상품 정보
  /// <br>
  /// EN: Product information
  final Commerce commerce;

  /// KO: 메시지 하단 버튼
  /// <br>
  /// EN: Button at the bottom of the message
  final List<Button>? buttons;

  /// KO: 버튼 문구
  /// <br>
  /// EN: Label for the button
  final String? buttonTitle;

  /// KO: 메시지 템플릿 타입, "commerce"로 고정
  /// <br>
  /// EN: Type of the message template, fixed as "commerce"
  final String objectType;

  /// @nodoc
  CommerceTemplate({
    required this.content,
    required this.commerce,
    this.buttons,
    this.buttonTitle,
    this.objectType = "commerce",
  });

  /// @nodoc
  factory CommerceTemplate.fromJson(Map<String, dynamic> json) =>
      _$CommerceTemplateFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$CommerceTemplateToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
