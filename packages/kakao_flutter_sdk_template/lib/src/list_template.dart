import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_template/src/default_template.dart';
import 'package:kakao_flutter_sdk_template/src/model/button.dart';
import 'package:kakao_flutter_sdk_template/src/model/content.dart';
import 'package:kakao_flutter_sdk_template/src/model/link.dart';

part 'list_template.g.dart';

/// KO: 리스트 메시지용 기본 템플릿
/// <br>
/// EN: Default template for list messages
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class ListTemplate extends DefaultTemplate {
  /// KO: 헤더 문구
  /// <br>
  /// EN: Title of the header
  final String headerTitle;

  /// KO: 헤더 바로가기 정보
  /// <br>
  /// EN: Link of the header
  final Link headerLink;

  /// KO: 메시지 콘텐츠
  /// <br>
  /// EN: Contents for the message
  final List<Content> contents;

  /// KO: 메시지 하단 버튼
  /// <br>
  /// EN: Button at the bottom of the message
  final List<Button>? buttons;

  /// KO: 버튼 문구
  /// <br>
  /// EN: Label for the button
  final String? buttonTitle;

  /// KO: 메시지 템플릿 타입, "list"로 고정
  /// <br>
  /// EN: Type of the message template, fixed as "list"
  final String objectType;

  /// @nodoc
  ListTemplate({
    required this.headerTitle,
    required this.headerLink,
    required this.contents,
    this.buttons,
    this.buttonTitle,
    this.objectType = "list",
  });

  /// @nodoc
  factory ListTemplate.fromJson(Map<String, dynamic> json) =>
      _$ListTemplateFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$ListTemplateToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
