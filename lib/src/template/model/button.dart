import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/template/model/link.dart';

part 'button.g.dart';

/// Button inside KakaoTalk message template v2.
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class Button {
  /// <nodoc>
  Button(this.title, this.link);

  final String title;
  final Link link;

  /// <nodoc>
  factory Button.fromJson(Map<String, dynamic> json) => _$ButtonFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$ButtonToJson(this);
}
