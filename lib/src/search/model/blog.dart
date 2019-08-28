import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/search/model/thumbnail_result.dart';

part 'blog.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Blog extends ThumbnailResult {
  Blog(String title, String contents, Uri url, DateTime datetime, Uri thumbnail,
      this.blogName)
      : super(title, contents, url, datetime, thumbnail);

  @JsonKey(name: "blogname")
  String blogName;

  /// <nodoc>
  factory Blog.fromJson(Map<String, dynamic> json) => _$BlogFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$BlogToJson(this);

  @override
  String toString() => toJson().toString();
}
