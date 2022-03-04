import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_template/src/default_template.dart';
import 'package:kakao_flutter_sdk_template/src/model/button.dart';
import 'package:kakao_flutter_sdk_template/src/model/content.dart';
import 'package:kakao_flutter_sdk_template/src/model/link.dart';

part 'list_template.g.dart';

/// 여러 개의 컨텐츠를 리스트 형태로 보여줄 수 있는 메시지 템플릿 클래스
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class ListTemplate extends DefaultTemplate {
  /// 리스트 상단에 노출되는 헤더 타이틀 (최대 200자)
  final String headerTitle;

  /// 헤더 타이틀 내용에 해당하는 링크 정보
  final Link headerLink;

  /// 리스트에 노출되는 컨텐츠 목록 (최소 2개, 최대 3개)
  final List<Content> contents;

  /// 버튼 목록. 버튼 타이틀과 링크를 변경하고 싶을때, 버튼 두개를 사용하고 싶을때 사용 (최대 2개)
  final List<Button>? buttons;

  /// 기본 버튼 타이틀(자세히 보기)을 변경하고 싶을 때 설정
  /// 이 값을 사용하면 클릭 시 이동할 링크는 content 에 입력된 값이 사용됨
  final String? buttonTitle;

  /// "list" 고정 값
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
