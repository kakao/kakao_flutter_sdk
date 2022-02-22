import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';

part 'shipping_address.g.dart';

/// 배송지 정보 클래스
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ShippingAddress {
  /// 배송지 ID
  int id;

  /// 배송지 이름
  String? name;

  /// 기본 배송지 여부
  bool isDefault;

  /// 수정시각의 timestamp
  @JsonKey(fromJson: Util.fromTimeStamp, toJson: Util.fromDateTime)
  DateTime? updatedAt;

  /// 배송지 타입
  /// 구주소(지번,번지 주소) 또는 신주소(도로명 주소)
  /// "OLD" or "NEW"
  String? type;

  /// 우편번호 검색시 채워지는 기본 주소
  String? baseAddress;

  /// 기본 주소에 추가하는 상세 주소
  String? detailAddress;

  /// 수령인 이름
  String? receiverName;

  /// 수령인 연락처
  String? receiverPhoneNumber1;

  /// 수령인 추가 연락처
  String? receiverPhoneNumber2;

  /// 신주소 우편번호. 신주소인 경우에 반드시 존재함.
  String? zoneNumber;

  /// 구주소 우편번호
  /// 우편번호를 소유하지 않는 구주소도 존재하여, 구주소인 경우도 해당값이 없을 수 있음
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
