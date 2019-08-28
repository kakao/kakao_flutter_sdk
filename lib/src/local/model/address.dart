import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/local/model/coord.dart';

part 'address.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Address extends Coord {
  final String addressName;
  @JsonKey(name: "region_1depth_name")
  final String region1depthName;
  @JsonKey(name: "region_2depth_name")
  final String region2depthName;
  @JsonKey(name: "region_3depth_name")
  final String region3depthName;
  @JsonKey(name: "region_3depth_h_name")
  final String region3depthHName;
  final String hCode;
  final String bCode;
  final String mountainYn;
  final String mainAddressNo;
  final String subAddressNo;
  final String zipCode;

  Address(
      this.addressName,
      this.region1depthName,
      this.region2depthName,
      this.region3depthName,
      this.region3depthHName,
      this.hCode,
      this.bCode,
      this.mountainYn,
      this.mainAddressNo,
      this.subAddressNo,
      this.zipCode,
      double x,
      double y)
      : super(x, y);

  /// <nodoc>
  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$AddressToJson(this);

  @override
  String toString() => toJson().toString();
}
