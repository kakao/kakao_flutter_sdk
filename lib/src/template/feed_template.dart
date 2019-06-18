import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/template/default_template.dart';
import 'package:kakao_flutter_sdk/src/template/model/button.dart';
import 'package:kakao_flutter_sdk/src/template/model/content.dart';
import 'package:kakao_flutter_sdk/src/template/model/social.dart';

export 'model/content.dart';
export 'model/social.dart';
export 'model/button.dart';

part 'feed_template.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class FeedTemplate extends DefaultTemplate {
  FeedTemplate(this.content,
      {this.social, this.buttons, this.objectType = "feed"});

  final Content content;
  final Social social;
  final List<Button> buttons;
  final String objectType;
  factory FeedTemplate.fromJson(Map<String, dynamic> json) =>
      _$FeedTemplateFromJson(json);
  Map<String, dynamic> toJson() => _$FeedTemplateToJson(this);
}
