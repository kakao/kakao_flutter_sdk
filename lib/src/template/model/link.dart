import 'package:json_annotation/json_annotation.dart';

part 'link.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Link {
  Link(
      {this.webUrl,
      this.mobileWebUrl,
      this.androidExecParams,
      this.iosExecParams});
  final String webUrl;
  final String mobileWebUrl;
  @JsonKey(name: "android_params")
  final String androidExecParams;
  @JsonKey(name: "ios_params")
  final String iosExecParams;

  factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);
  Map<String, dynamic> toJson() => _$LinkToJson(this);
}
