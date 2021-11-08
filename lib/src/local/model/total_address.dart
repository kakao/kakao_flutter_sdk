import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/local/model/address.dart';
import 'package:kakao_flutter_sdk/src/local/model/coord.dart';
import 'package:kakao_flutter_sdk/src/local/model/road_address.dart';

part 'total_address.g.dart';

/// Wrapper for land-lot based address and street name adress.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class TotalAddress extends Coord {
  final String? addressName;
  final AddressType? addressType;

  final Address? address;
  final RoadAddress? roadAddress;

  TotalAddress(this.addressName, this.addressType, double x, double y,
      this.address, this.roadAddress)
      : super(x, y);

  /// <nodoc>
  factory TotalAddress.fromJson(Map<String, dynamic> json) =>
      _$TotalAddressFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$TotalAddressToJson(this);

  @override
  String toString() => toJson().toString();
}

enum AddressType { REGION, ROAD, REGION_ADDR, ROAD_ADDR }
