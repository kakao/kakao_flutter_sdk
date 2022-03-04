import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

part 'link.g.dart';

/// 메시지에서 콘텐츠 영역이나 버튼 클릭 시에 이동되는 링크 정보 오브젝트
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Link {
  /// PC 버전 카카오톡에서 사용하는 웹 링크 URL
  final Uri? webUrl;

  /// 모바일 카카오톡에서 사용하는 웹 링크 URL
  final Uri? mobileWebUrl;

  /// 안드로이드 카카오톡에서 사용하는 앱 링크 URL에 추가할 파라미터
  @JsonKey(
      name: "android_execution_params",
      fromJson: Util.stringToMap,
      toJson: Util.mapToString)
  final Map<String, String>? androidExecutionParams;

  /// iOS 카카오톡에서 사용하는 앱 링크 URL에 추가할 파라미터
  @JsonKey(
      name: "ios_execution_params",
      fromJson: Util.stringToMap,
      toJson: Util.mapToString)
  final Map<String, String>? iosExecutionParams;

  /// @nodoc
  Link({
    this.webUrl,
    this.mobileWebUrl,
    this.androidExecutionParams,
    this.iosExecutionParams,
  });

  /// @nodoc
  factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$LinkToJson(this);
}
