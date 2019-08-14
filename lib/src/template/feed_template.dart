import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/template/default_template.dart';
import 'package:kakao_flutter_sdk/src/template/model/button.dart';
import 'package:kakao_flutter_sdk/src/template/model/content.dart';
import 'package:kakao_flutter_sdk/src/template/model/social.dart';

part 'feed_template.g.dart';

/// Default template for feed type.
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class FeedTemplate extends DefaultTemplate {
  /// <nodoc>
  FeedTemplate(this.content,
      {this.social, this.buttons, this.objectType = "feed"});

  final Content content;
  final Social social;

  // Buttons . Currently supports maximum of 2 buttons.
  final List<Button> buttons;
  final String objectType;

  /// <nodoc>
  factory FeedTemplate.fromJson(Map<String, dynamic> json) =>
      _$FeedTemplateFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$FeedTemplateToJson(this);
}
