import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_template/src/default_template.dart';
import 'package:kakao_flutter_sdk_template/src/model/button.dart';
import 'package:kakao_flutter_sdk_template/src/model/commerce.dart';
import 'package:kakao_flutter_sdk_template/src/model/content.dart';

part 'commerce_template.g.dart';

/// 기본 템플릿으로 제공되는 커머스 템플릿 클래스
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class CommerceTemplate extends DefaultTemplate {
  /// 메시지의 내용. 텍스트 및 이미지, 링크 정보 포함
  final Content content;

  /// 컨텐츠에 대한 가격 정보
  final Commerce commerce;

  /// 버튼 목록. 버튼 타이틀과 링크를 변경하고 싶을때, 버튼 두개를 사용하고 싶을때 사용 (최대 2개)
  final List<Button>? buttons;

  /// 기본 버튼 타이틀(자세히 보기)을 변경하고 싶을 때 설정
  /// 이 값을 사용하면 클릭 시 이동할 링크는 content 에 입력된 값이 사용됨
  final String? buttonTitle;

  /// "commerce" 고정 값
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
