import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/template/default_template.dart';
import 'package:kakao_flutter_sdk/src/template/model/button.dart';
import 'package:kakao_flutter_sdk/src/template/model/content.dart';
import 'package:kakao_flutter_sdk/src/template/model/social.dart';

import 'model/item_content.dart';

part 'feed_template.g.dart';

/// Default template for feed type.
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class FeedTemplate extends DefaultTemplate {
  /// Main content information of the message.
  final Content content;

  /// Contents to be included in the item area. Please refer to [ItemContent].
  final ItemContent? itemContent;

  /// Social information about the contents.
  final Social? social;

  /// List of buttons, up to 2. Use when you want to change the title and link of the button, and when you want to insert two buttons.
  final List<Button>? buttons;
  final String? buttonTitle;
  final String objectType;

  /// <nodoc>
  FeedTemplate(this.content,
      {this.itemContent,
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
