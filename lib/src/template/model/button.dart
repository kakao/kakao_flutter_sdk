import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/template/model/link.dart';

part 'button.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class Button {
  Button(this.title, this.link);
  final String title;
  final Link link;

  factory Button.fromJson(Map<String, dynamic> json) => _$ButtonFromJson(json);
  Map<String, dynamic> toJson() => _$ButtonToJson(this);
}
