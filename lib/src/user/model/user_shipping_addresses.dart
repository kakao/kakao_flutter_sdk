import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/user/model/shipping_address.dart';

part 'user_shipping_addresses.g.dart';

/// Response from [UserApi.shippingAddresses()].
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class UserShippingAddresses {
  int? userId;
  @JsonKey(name: "shipping_addresses_needs_agreement")
  bool needsAgreement;
  List<ShippingAddress>? shippingAddresses;

  /// <nodoc>
  UserShippingAddresses(
      this.userId, this.needsAgreement, this.shippingAddresses);

  /// <nodoc>
  factory UserShippingAddresses.fromJson(Map<String, dynamic> json) =>
      _$UserShippingAddressesFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$UserShippingAddressesToJson(this);
}
