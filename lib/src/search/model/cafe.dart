import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/search/model/thumbnail_result.dart';

part 'cafe.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Cafe extends ThumbnailResult {
  Cafe(String title, String contents, Uri url, DateTime datetime, Uri thumbnail,
      this.cafeName)
      : super(title, contents, url, datetime, thumbnail);

  @JsonKey(name: "cafename")
  String cafeName;

  /// <nodoc>
  factory Cafe.fromJson(Map<String, dynamic> json) => _$CafeFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$CafeToJson(this);

  @override
  String toString() => toJson().toString();
}
