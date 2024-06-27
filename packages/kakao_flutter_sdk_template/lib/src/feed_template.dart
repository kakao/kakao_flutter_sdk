import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_template/src/default_template.dart';
import 'package:kakao_flutter_sdk_template/src/model/button.dart';
import 'package:kakao_flutter_sdk_template/src/model/content.dart';
import 'package:kakao_flutter_sdk_template/src/model/social.dart';

import 'model/item_content.dart';

part 'feed_template.g.dart';

/// KO: 피드 메시지용 기본 템플릿
/// <br>
/// EN: Default template for feed messages
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class FeedTemplate extends DefaultTemplate {
  /// KO: 메시지 콘텐츠
  /// <br>
  /// EN: Contents for the message
  final Content content;

  /// KO: 아이템 콘텐츠
  /// <br>
  /// EN: Item contents
  final ItemContent? itemContent;

  /// KO: 소셜 정보
  /// <br>
  /// EN: Social information
  final Social? social;

  /// KO: 메시지 하단 버튼
  /// <br>
  /// EN: Button at the bottom of the message
  final List<Button>? buttons;

  /// KO: 버튼 문구
  /// <br>
  /// EN: Label for the button
  final String? buttonTitle;

  /// KO: 메시지 템플릿 타입, "feed"로 고정
  /// <br>
  /// EN: Type of the message template, fixed as "feed"
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
