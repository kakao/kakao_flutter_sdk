import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/local/model/coord.dart';

part 'place.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Place extends Coord {
  String id;
  String placeName;
  String categoryName;
  @JsonKey(unknownEnumValue: CategoryGroup.UNKNOWN)
  CategoryGroup categoryGroupCode;
  String categoryGroupName;
  String phone;
  String addressName;
  String roadAddressName;
  Uri placeUrl;
  @JsonKey(fromJson: stringToInt)
  int distance;

  Place(
      this.id,
      this.placeName,
      this.categoryName,
      this.categoryGroupCode,
      this.categoryGroupName,
      this.phone,
      this.addressName,
      this.roadAddressName,
      this.placeUrl,
      this.distance,
      double x,
      double y)
      : super(x, y);

  /// <nodoc>
  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$PlaceToJson(this);

  @override
  String toString() => toJson().toString();
}

enum CategoryGroup {
  MT1,
  CS2,
  PS3,
  SC4,
  AC5,
  PK6,
  OL7,
  SW8,
  BK9,
  CT1,
  AG2,
  PO3,
  AT4,
  AD5,
  FD6,
  CE7,
  HP8,
  PM9,
  UNKNOWN
}
