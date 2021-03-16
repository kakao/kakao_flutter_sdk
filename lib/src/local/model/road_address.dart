import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/local/model/coord.dart';
import 'package:kakao_flutter_sdk/src/local/model/nullable_coord.dart';

part 'road_address.g.dart';

/// Represents road (or street name) address, which is the new standard in South Korea.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class RoadAddress extends NullableCoord {
  /// full road address
  final String addressName;

  /// 지역명1
  @JsonKey(name: "region_1depth_name")
  final String region1depthName;

  /// 지역명2
  @JsonKey(name: "region_2depth_name")
  final String region2depthName;

  /// 지역명3
  @JsonKey(name: "region_3depth_name")
  final String region3depthName;

  final String roadName;

  /// whether this address is underground or not
  final String undergroundYn;

  final String mainBuildingNo;
  final String subBuildingNo;
  final String buildingName;

  /// poastal code (5 digits)
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
      double? x,
      double? y)
      : super(x, y);

  /// <nodoc>
  factory RoadAddress.fromJson(Map<String, dynamic> json) =>
      _$RoadAddressFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$RoadAddressToJson(this);

  @override
  String toString() => toJson().toString();
}
