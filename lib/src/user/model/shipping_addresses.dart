import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/user/model/shipping_address.dart';

part 'shipping_addresses.g.dart';

/// Response from [UserApi.shippingAddresses()].
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class ShippingAddresses {
  int userId;
  @JsonKey(name: "shipping_addresses_needs_agreement")
  bool needsAgreement;
  List<ShippingAddress>? shippingAddresses;

  /// <nodoc>
  ShippingAddresses(this.userId, this.needsAgreement, this.shippingAddresses);

  /// <nodoc>
  factory ShippingAddresses.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressesFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$ShippingAddressesToJson(this);
}
