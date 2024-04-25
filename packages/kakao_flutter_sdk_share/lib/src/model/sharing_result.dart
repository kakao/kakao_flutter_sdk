import 'package:json_annotation/json_annotation.dart';

part 'sharing_result.g.dart';

/// KO: 카카오톡 공유 결과
/// <br>
/// EN: Kakao Talk Sharing result
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class SharingResult {
  /// KO: 사용자 정의 템플릿 ID
  /// <br>
  /// EN: Custom template ID
  int templateId;

  /// KO: 사용자 인자 키와 값
  /// <br>
  /// EN: Keys and values of the user argument
  Map<String, dynamic>? templateArgs;

  /// KO: 사용자 정의 템플릿 ID에 해당하는 메시지 템플릿의 전문
  /// <br>
  /// EN: Full message template contents of the custom template ID
  Map<String, dynamic> templateMsg;

  /// KO: 메시지 템플릿 검증 결과
  /// <br>
  /// EN: Message template validation result
  Map<String, dynamic> warningMsg;

  /// KO: 사용자 인자 검증 결과
  /// <br>
  /// EN: User argument validation result
  Map<String, dynamic> argumentMsg;

  /// @nodoc
  SharingResult(this.templateId, this.templateArgs, this.templateMsg,
      this.warningMsg, this.argumentMsg);

  /// @nodoc
  factory SharingResult.fromJson(Map<String, dynamic> json) =>
      _$SharingResultFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$SharingResultToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
