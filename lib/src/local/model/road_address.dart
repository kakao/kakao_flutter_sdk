import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/local/model/coord.dart';

part 'road_address.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class RoadAddress extends Coord {
  final String addressName;
  @JsonKey(name: "region_1depth_name")
  final String region1depthName;
  @JsonKey(name: "region_2depth_name")
  final String region2depthName;
  @JsonKey(name: "region_3depth_name")
  final String region3depthName;
  final String roadName;
  final String undergroundYn;
  final String mainBuildingNo;
  final String subBuildingNo;
  final String buildingName;
  final String zoneNo;

  RoadAddress(
      this.addressName,
      this.region1depthName,
      this.region2depthName,
      this.region3depthName,
      this.roadName,
      this.undergroundYn,
      this.mainBuildingNo,
      this.subBuildingNo,
      this.buildingName,
      this.zoneNo,
      double x,
      double y)
      : super(x, y);

  /// <nodoc>
  factory RoadAddress.fromJson(Map<String, dynamic> json) =>
      _$RoadAddressFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$RoadAddressToJson(this);

  @override
  String toString() => toJson().toString();
}
