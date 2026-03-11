import 'package:json_annotation/json_annotation.dart';

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
    name: 'android_execution_params',
    fromJson: _queryStringToMap,
    toJson: _mapToQueryString,
  )
  final Map<String, String>? androidExecutionParams;

  /// KO: iOS 앱 실행 시 전달할 파라미터
  /// <br>
  /// EN: Parameters to pass to the iOS app
  @JsonKey(
    name: 'ios_execution_params',
    fromJson: _queryStringToMap,
    toJson: _mapToQueryString,
  )
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

  static Map<String, String>? _queryStringToMap(String? queries) {
    if (queries == null) return null;

    final queryMap = <String, String>{};
    queries.split('&').forEach((query) {
      final splitQuery = query.split('=');
      final key = splitQuery.firstOrNull;
      final value = splitQuery.lastOrNull;

      if (key != null && value != null) {
        queryMap[key] = value;
      }
    });
    return Map.from(queryMap);
  }

  static String? _mapToQueryString(Map<String, String>? map) {
    if (map == null) return null;

    return Uri(queryParameters: map).query;
  }
}
