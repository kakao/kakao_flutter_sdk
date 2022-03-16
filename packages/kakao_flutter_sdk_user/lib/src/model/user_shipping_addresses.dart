import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_user/src/model/shipping_address.dart';

part 'user_shipping_addresses.g.dart';

/// 앱에 가입한 사용자의 배송지 정보 API 응답 클래스
///
/// 배송지의 정렬 순서는 기본배송지가 무조건 젤 먼저, 그후에는 배송지 수정된 시각을 기준으로 최신순으로 정렬되어 나가고, 페이지 사이즈를 주어서 여러 페이지를 나누어 조회하거나, 특정 배송지 아이디만을 지정하여 해당 배송지 정보만을 조회 가능
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class UserShippingAddresses {
  /// 배송지 정보를 요청한 회원번호
  int? userId;

  /// 배송지 정보 조회를 위하여 유저에게 제3자 정보제공동의를 받아야 하는지 여부
  @JsonKey(name: "shipping_addresses_needs_agreement")
  bool needsAgreement;

  /// 사용자의 배송지 정보 리스트
  /// 최신 수정순 (단, 기본 배송지는 수정시각과 상관없이 첫번째에 위치)
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
