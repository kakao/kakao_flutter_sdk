import 'package:json_annotation/json_annotation.dart';

part 'vclip.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class VClip {
  String title;
  Uri url;
  DateTime datetime;
  int playTime;
  Uri thumbnail;
  String author;

  VClip(this.title, this.url, this.datetime, this.playTime, this.thumbnail,
      this.author);

  /// <nodoc>
  factory VClip.fromJson(Map<String, dynamic> json) => _$VClipFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$VClipToJson(this);

  @override
  String toString() => toJson().toString();
}
