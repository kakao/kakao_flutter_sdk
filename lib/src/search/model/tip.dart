import 'package:json_annotation/json_annotation.dart';

part 'tip.g.dart';

@JsonSerializable(includeIfNull: false)
class Tip {
  String title;
  String contents;
  @JsonKey(name: "q_url")
  Uri questionUrl;
  @JsonKey(name: "a_url")
  Uri answerUrl;
  List<Uri> thumbnails;
  String type;
  DateTime datetime;

  Tip(this.title, this.contents, this.datetime, this.questionUrl,
      this.answerUrl, this.thumbnails, this.type);

  /// <nodoc>
  factory Tip.fromJson(Map<String, dynamic> json) => _$TipFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$TipToJson(this);

  @override
  String toString() => toJson().toString();
}
