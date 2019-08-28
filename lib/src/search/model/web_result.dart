import 'package:json_annotation/json_annotation.dart';

part 'web_result.g.dart';

@JsonSerializable(includeIfNull: false)
class WebResult {
  String title;
  String contents;
  Uri url;
  DateTime datetime;

  WebResult(this.title, this.contents, this.url, this.datetime);

  /// <nodoc>
  factory WebResult.fromJson(Map<String, dynamic> json) =>
      _$WebResultFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$WebResultToJson(this);

  @override
  String toString() => toJson().toString();
}
