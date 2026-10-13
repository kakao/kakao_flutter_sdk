import 'package:json_annotation/json_annotation.dart';

import 'shipping_address.dart';

part 'user_shipping_address.g.dart';

/// KO: 배송지 조회 응답
/// <br>
/// EN: Response for Retrieve shipping address
@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
  includeIfNull: false,
)
class UserShippingAddress {
  /// KO: 회원번호
  /// <br>
  /// EN: Service user ID
  final int? userId;

  /// KO: 사용자 동의 시 배송지 제공 가능 여부
  /// <br>
  /// EN: Whether `shippingAddress` can be provided under user consent
  @JsonKey(name: 'shipping_address_needs_agreement')
  final bool? needsAgreement;

  /// KO: 배송지 정보, 조회 가능한 배송지가 없거나 사용자 동의가 필요한 경우 `null`
  /// <br>
  /// EN: Shipping address, `null` if there is no shipping address to retrieve or user consent is required
  final ShippingAddress? shippingAddress;

  /// @nodoc
  UserShippingAddress(this.userId, this.needsAgreement, this.shippingAddress);

  /// @nodoc
  factory UserShippingAddress.fromJson(Map<String, dynamic> json) =>
      _$UserShippingAddressFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$UserShippingAddressToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
