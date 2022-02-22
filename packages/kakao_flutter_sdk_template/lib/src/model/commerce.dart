import 'package:json_annotation/json_annotation.dart';

part 'commerce.g.dart';

/// 가격 정보를 표현하기 위해 사용되는 오브젝트
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Commerce {
  /// 정상가격
  final int regularPrice;

  /// 할인된 가격
  final int? discountPrice;

  /// 정액 할인 가격
  final int? fixedDiscountPrice;

  /// 할인율
  final int? discountRate;

  /// 상품명
  final String? productName;

  /// 가격 단위
  final String? currencyUnit;

  /// 가격 단위 위치 (0: 가격뒤에 단위 표시, 1 : 가격앞에 단위 표시)
  final int? currencyUnitPosition;

  /// @nodoc
  Commerce({
    required this.regularPrice,
    this.discountPrice,
    this.fixedDiscountPrice,
    this.discountRate,
    this.productName,
    this.currencyUnit,
    this.currencyUnitPosition,
  });

  /// @nodoc
  factory Commerce.fromJson(Map<String, dynamic> json) =>
      _$CommerceFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$CommerceToJson(this);
}
