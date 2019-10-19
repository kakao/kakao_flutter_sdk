import 'package:json_annotation/json_annotation.dart';

part 'link.g.dart';

/// Collection of links to open whe a specific area in KakaoTalk message is tapped.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Link {
  /// <nodoc>
  Link(
      {this.webUrl,
      this.mobileWebUrl,
      this.androidExecParams,
      this.iosExecParams});

  /// Url to open in PC or MacOS KakaoTalk.
  final Uri webUrl;

  /// Url to open in mobile KakaoTalk in-app browser.
  final Uri mobileWebUrl;

  /// query string to be passed to custom scheme in Android.
  ///
  /// example:
  ///
  /// If
  ///
  /// ```
  /// androidExecParams: key1=value1&key2=value2
  /// registered custom scheme: "kakao${kakao_app_key}://kakaolink"
  /// ```
  ///
  /// Then, below scheme will be called.
  /// ```
  /// "kakao${kakao_app_key}://kakaolink?key1=value1&key2=value"
  /// ```
  ///
  /// These query paramters can then be parsed to direct users to appropriate screen.
  ///
  @JsonKey(name: "android_execution_params")
  final String androidExecParams;

  /// query string to be passed to custom scheme in iOS.
  ///
  /// example:
  ///
  /// If
  ///
  /// ```
  /// androidExecParams: key1=value1&key2=value2
  /// registered custom scheme: "kakao${kakao_app_key}://kakaolink"
  /// ```
  ///
  /// Then, below scheme will be called.
  /// ```
  /// "kakao${kakao_app_key}://kakaolink?key1=value1&key2=value"
  /// ```
  ///
  /// These query paramters can then be parsed to direct users to appropriate screen.
  ///
  @JsonKey(name: "ios_execution_params")
  final String iosExecParams;

  /// <nodoc>
  factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$LinkToJson(this);
}
