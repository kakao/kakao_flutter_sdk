import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_template/src/model/link.dart';

part 'button.g.dart';

/// KO: 메시지 하단 버튼
/// <br>
/// EN: Button at the bottom of the message
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class Button {
  /// KO: 버튼 문구
  /// <br>
  /// EN: Label for the button
  final String title;

  /// KO: 바로가기 URL
  /// <br>
  /// EN: Link URL
  final Link link;

  /// @nodoc
  Button({required this.title, required this.link});

  /// @nodoc
  factory Button.fromJson(Map<String, dynamic> json) => _$ButtonFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$ButtonToJson(this);
}
