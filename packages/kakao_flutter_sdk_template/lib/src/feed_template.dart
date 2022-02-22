import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_template/src/default_template.dart';
import 'package:kakao_flutter_sdk_template/src/model/button.dart';
import 'package:kakao_flutter_sdk_template/src/model/content.dart';
import 'package:kakao_flutter_sdk_template/src/model/social.dart';

import 'model/item_content.dart';

part 'feed_template.g.dart';

/// 기본 템플릿으로 제공되는 피드 템플릿 클래스
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class FeedTemplate extends DefaultTemplate {
  /// 메시지의 메인 콘텐츠 정보
  final Content content;

  /// 아이템 영역에 포함할 콘텐츠, [ItemContent] 참고
  final ItemContent? itemContent;

  /// 콘텐츠에 대한 소셜 정보
  final Social? social;

  /// 버튼 목록, 최대 2개. 버튼 타이틀과 링크를 변경하고 싶을 때, 버튼 두 개를 넣고 싶을 때 사용
  final List<Button>? buttons;

  /// 기본 버튼 타이틀(자세히 보기)을 변경하고 싶을 때 설정
  /// 이 값을 사용하면 클릭 시 이동할 링크는 content 에 입력된 값이 사용됨
  final String? buttonTitle;

  /// "feed" 고정 값
  final String objectType;

  /// @nodoc
  FeedTemplate({
    required this.content,
    this.itemContent,
    this.social,
    this.buttons,
    this.buttonTitle,
    this.objectType = "feed",
  });

  /// @nodoc
  factory FeedTemplate.fromJson(Map<String, dynamic> json) =>
      _$FeedTemplateFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$FeedTemplateToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
