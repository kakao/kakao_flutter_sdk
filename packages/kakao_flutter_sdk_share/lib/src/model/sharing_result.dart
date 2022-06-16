import 'package:json_annotation/json_annotation.dart';

part 'sharing_result.g.dart';

/// 카카오톡 공유 API 호출 결과
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class SharingResult {
  /// 메시지 템플릿 도구에서 구성한 사용자 정의 템플릿의 ID
  int templateId;

  /// templateId로 지정한 템플릿에 사용자 인자
  Map<String, dynamic>? templateArgs;

  /// templateId에 해당하는 template 전체 message
  Map<String, dynamic> templateMsg;

  /// 템플릿 검증 결과
  Map<String, dynamic> warningMsg;

  /// templateArgs 검증 결과
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
