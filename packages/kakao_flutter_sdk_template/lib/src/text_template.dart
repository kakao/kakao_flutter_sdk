import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_template/src/default_template.dart';
import 'package:kakao_flutter_sdk_template/src/model/button.dart';
import 'package:kakao_flutter_sdk_template/src/model/link.dart';

part 'text_template.g.dart';

/// 텍스트형 기본 템플릿 클래스
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class TextTemplate extends DefaultTemplate {
  /// 메시지에 들어갈 텍스트 (최대 200자)
  final String text;

  /// 컨텐츠 클릭 시 이동할 링크 정보
  final Link link;

  /// 버튼 목록
  /// 버튼 타이틀과 링크를 변경하고 싶을때, 버튼 두개를 사용하고 싶을때 사용 (최대 2개)
  final List<Button>? buttons;

  /// 기본 버튼 타이틀(자세히 보기)을 변경하고 싶을 때 설정
  /// 이 값을 사용하면 클릭 시 이동할 링크는 content에 입력된 값이 사용됨
  final String? buttonTitle;

  /// "text" 고정 값
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
