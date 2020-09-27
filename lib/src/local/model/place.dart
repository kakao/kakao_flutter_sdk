import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/local/model/coord.dart';

part 'place.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Place extends Coord {
  String id;
  String placeName;

  /// ex. 가정,생활 > 문구,사무용품 > 디자인문구 > 카카오프렌즈
  String categoryName;

  /// refer to https://developers.kakao.com/docs/latest/ko/local/dev-guide for detail.
  @JsonKey(unknownEnumValue: CategoryGroup.UNKNOWN)
  CategoryGroup categoryGroupCode;
  String categoryGroupName;

  /// phone number of this place
  String phone;

  /// full land-lot based address
  String addressName;

  /// full road address
  String roadAddressName;

  Uri placeUrl;

  /// distance from the center coordinate. Only exists when x and y parameters are provided to the API.
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

/// Code for category groups.
enum CategoryGroup {
  /// market
  MT1,

  /// convenience store
  CS2,

  /// kindergarten
  PS3,

  /// school
  SC4,

  /// private institute (학원)
  AC5,

  /// parking lot
  PK6,

  /// gas station
  OL7,

  /// subway station
  SW8,

  /// bank
  BK9,

  /// cultural facility (문화시설)
  CT1,

  /// brokerage agency (중개업소)
  AG2,

  /// public institution
  PO3,

  /// tourist attraction
  AT4,

  /// accomodation (숙박업소)
  AD5,

  /// restaurants
  FD6,

  ///cafe
  CE7,

  /// hospital
  HP8,

  ///pharmacy
  PM9,
  UNKNOWN
}
