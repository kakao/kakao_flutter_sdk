import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/local/model/coord.dart';

part 'region.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Region extends Coord {
  final String regionType;
  final String addressName;
  @JsonKey(name: "region_1depth_name")
  final String region1depthName;
  @JsonKey(name: "region_2depth_name")
  final String region2depthName;
  @JsonKey(name: "region_3depth_name")
  final String region3depthName;
  @JsonKey(name: "region_4depth_name")
  final String region4depthName;

  final String code;

  Region(
      this.regionType,
      this.addressName,
      this.region1depthName,
      this.region2depthName,
      this.region3depthName,
      this.region4depthName,
      this.code,
      double x,
      double y)
      : super(x, y);

  /// <nodoc>
  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$RegionToJson(this);

  @override
  String toString() => toJson().toString();
}
