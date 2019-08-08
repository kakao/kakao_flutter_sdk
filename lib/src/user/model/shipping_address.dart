import 'package:json_annotation/json_annotation.dart';

part 'shipping_address.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ShippingAddress {
  int id;
  String name;
  bool isDefault;
  int updatedAt;
  String type;
  String baseAddress;
  String detailAddress;
  String receiverName;
  String receiverPhoneNumber1;
  String receiverPhoneNumber2;
  String zoneNumber;
  String zipCode;

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

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressFromJson(json);
  Map<String, dynamic> toJson() => _$ShippingAddressToJson(this);
}
