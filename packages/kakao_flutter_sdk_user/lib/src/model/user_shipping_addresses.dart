import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_user/src/model/shipping_address.dart';

part 'user_shipping_addresses.g.dart';

/// KO: 배송지 가져오기 응답
/// <br>
/// EN: Response for Retrieve shipping address
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class UserShippingAddresses {
  /// KO: 회원번호
  /// <br>
  /// EN: Service user ID
  int? userId;

  /// KO: 사용자 동의 시 배송지 제공 가능 여부
  /// <br>
  /// EN: Whether `shippingAddresses` can be provided under user consent
  @JsonKey(name: "shipping_addresses_needs_agreement")
  bool? needsAgreement;

  /// KO: 배송지 목록
  /// <br>
  /// EN: List of shipping addresses
  List<ShippingAddress>? shippingAddresses;

  /// @nodoc
  UserShippingAddresses(
      this.userId, this.needsAgreement, this.shippingAddresses);

  /// @nodoc
  factory UserShippingAddresses.fromJson(Map<String, dynamic> json) =>
      _$UserShippingAddressesFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$UserShippingAddressesToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
