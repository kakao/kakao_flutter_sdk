import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_template/src/model/link.dart';

part 'button.g.dart';

/// 메시지 하단에 추가되는 버튼 오브젝트
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class Button {
  /// 버튼의 타이틀
  final String title;

  /// 버튼 클릭 시 이동할 링크 정보
  final Link link;

  /// @nodoc
  Button({required this.title, required this.link});

  /// @nodoc
  factory Button.fromJson(Map<String, dynamic> json) => _$ButtonFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$ButtonToJson(this);
}
