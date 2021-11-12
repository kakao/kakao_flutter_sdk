import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Location {
  final String name;
  final String x;
  final String y;
  @JsonKey(name: "rpflag")
  final String? rpFlag;

  /// <nodoc>
  Location(this.name, this.x, this.y, {this.rpFlag});

  /// <nodoc>
  Map<String, dynamic> toJson() => _$LocationToJson(this);

  /// <nodoc>
  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}
