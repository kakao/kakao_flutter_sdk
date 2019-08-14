import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/common.dart';

part 'shipping_address.g.dart';

/// Individual shipping address.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ShippingAddress {
  int id;
  String name;
  bool isDefault;
  @JsonKey(fromJson: Util.fromTimeStamp, toJson: Util.fromDateTime)
  DateTime updatedAt;
  String type;
  String baseAddress;
  String detailAddress;
  String receiverName;
  String receiverPhoneNumber1;
  String receiverPhoneNumber2;
  String zoneNumber;
  String zipCode;

  /// <nodoc>
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

  /// <nodoc>
  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$ShippingAddressToJson(this);
}
