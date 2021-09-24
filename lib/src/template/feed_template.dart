import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/template/default_template.dart';
import 'package:kakao_flutter_sdk/src/template/model/button.dart';
import 'package:kakao_flutter_sdk/src/template/model/content.dart';
import 'package:kakao_flutter_sdk/src/template/model/social.dart';

import 'model/feed.dart';

part 'feed_template.g.dart';

/// Default template for feed type.
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class FeedTemplate extends DefaultTemplate {
  final Content content;
  final Social? social;

  /// Content of the message. Include content in the form of an item list.
  final Feed? feed;

  /// Buttons. Currently supports maximum of 2 buttons.
  final List<Button>? buttons;
  final String? buttonTitle;
  final String objectType;

  /// <nodoc>
  FeedTemplate(this.content,
      {this.feed,
      this.social,
      this.buttons,
      this.buttonTitle,
      this.objectType = "feed"});

  /// <nodoc>
  factory FeedTemplate.fromJson(Map<String, dynamic> json) =>
      _$FeedTemplateFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$FeedTemplateToJson(this);
}
