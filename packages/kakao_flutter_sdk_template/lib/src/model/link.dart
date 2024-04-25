import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

part 'link.g.dart';

/// KO: 바로가기 정보
/// <br>
/// EN: Link information
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Link {
  /// KO: 웹 URL
  /// <br>
  /// EN: Web URL
  final Uri? webUrl;

  /// KO: 모바일 웹 URL
  /// <br>
  /// EN: Mobile web URL
  final Uri? mobileWebUrl;

  /// KO: Android 앱 실행 시 전달할 파라미터
  /// <br>
  /// EN: Parameters to pass to the Android app
  @JsonKey(
      name: "android_execution_params",
      fromJson: Util.stringToMap,
      toJson: Util.mapToString)
  final Map<String, String>? androidExecutionParams;

  /// KO: iOS 앱 실행 시 전달할 파라미터
  /// <br>
  /// EN: Parameters to pass to the iOS app
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
