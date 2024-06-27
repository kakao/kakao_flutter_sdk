import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';

part 'shipping_address.g.dart';

/// KO: 배송지 정보
/// <br>
/// EN: Shipping address information
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ShippingAddress {
  /// KO: 배송지 ID
  /// <br>
  /// EN: Shipping address ID
  int id;

  /// KO: 배송지 이름
  /// <br>
  /// EN: Name of shipping address
  String? name;

  /// KO: 기본 배송지 여부
  /// <br>
  /// EN: Whether shipping address is default
  bool isDefault;

  /// KO: 수정 시각
  /// <br>
  /// EN: Updated time
  @JsonKey(fromJson: Util.fromTimeStamp, toJson: Util.fromDateTime)
  DateTime? updatedAt;

  /// KO: 배송지 타입 (OLD: 구주소 | NEW: 신주소)
  /// <br>
  /// EN: Shipping address type (OLD: Administrative address | NEW: Road name address)
  String? type;

  /// KO: 우편번호 검색 시 채워지는 기본 주소
  /// <br>
  /// EN: Base address that is automatically input when searching for a zipcode
  String? baseAddress;

  /// KO: 기본 주소에 추가하는 상세 주소
  /// <br>
  /// EN: Detailed address that a user adds to the base address
  String? detailAddress;

  /// KO: 수령인 이름
  /// <br>
  /// EN: Recipient name
  String? receiverName;

  /// KO: 수령인 연락처
  /// <br>
  /// EN: Recipient phone number
  String? receiverPhoneNumber1;

  /// KO: 수령인 추가 연락처
  /// <br>
  /// EN: Additional recipient phone number
  String? receiverPhoneNumber2;

  /// KO: 신주소 우편번호
  /// <br>
  /// EN: 5-digit postal code for a road name address system
  String? zoneNumber;

  /// KO: 구주소 우편번호
  /// <br>
  /// EN: Old type of 6-digit postal code for an administrative address system
  String? zipCode;

  /// @nodoc
  ShippingAddress(
      this.id,
      this.name,
      this.isDefault,
      this.updatedAt,
      this.type,
      this.baseAddress,
      this.detailAddress,
      this.receiverName,
      this.receiverPhoneNumber1,
      this.receiverPhoneNumber2,
      this.zoneNumber,
      this.zipCode);

  /// @nodoc
  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$ShippingAddressToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
