import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/user/model/shipping_address.dart';

part 'shipping_addresses.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class ShippingAddresses {
  int userId;
  bool shippingAddressesNeedsAgreement;
  List<ShippingAddress> shippingAddresses;

  ShippingAddresses(this.userId, this.shippingAddressesNeedsAgreement,
      this.shippingAddresses);

  factory ShippingAddresses.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressesFromJson(json);
  Map<String, dynamic> toJson() => _$ShippingAddressesToJson(this);
}
