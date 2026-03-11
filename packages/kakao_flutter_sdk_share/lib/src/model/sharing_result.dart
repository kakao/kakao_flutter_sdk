import 'package:json_annotation/json_annotation.dart';

part 'sharing_result.g.dart';

/// @nodoc
// 카카오톡 공유 결과
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class SharingResult {
  final int templateId;
  final Map<String, dynamic>? templateArgs;
  final Map<String, dynamic> templateMsg;
  final Map<String, dynamic> warningMsg;
  final Map<String, dynamic> argumentMsg;
  final Map<String, dynamic>? schemeParams;

  SharingResult(this.templateId, this.templateArgs, this.templateMsg,
      this.warningMsg, this.argumentMsg, this.schemeParams);

  factory SharingResult.fromJson(Map<String, dynamic> json) =>
      _$SharingResultFromJson(json);

  Map<String, dynamic> toJson() => _$SharingResultToJson(this);

  @override
  String toString() => toJson().toString();
}
