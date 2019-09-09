import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/search/model/web_result.dart';

part 'thumbnail_result.g.dart';

@JsonSerializable(includeIfNull: false)
class ThumbnailResult extends WebResult {
  ThumbnailResult(
      String title, String contents, Uri url, DateTime datetime, Uri thumbnail)
      : super(title, contents, url, datetime) {
    this.thumbnail = thumbnail;
  }
  Uri thumbnail;

  /// <nodoc>
  factory ThumbnailResult.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailResultFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$ThumbnailResultToJson(this);
}
