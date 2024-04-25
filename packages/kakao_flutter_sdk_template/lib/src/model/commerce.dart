import 'package:json_annotation/json_annotation.dart';

part 'commerce.g.dart';

/// KO: 상품 정보
/// <br>
/// EN: Product information
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Commerce {
  /// KO: 정가
  /// <br>
  /// EN: Regular price
  final int regularPrice;

  /// KO: 할인 가격
  /// <br>
  /// EN: Discount price
  final int? discountPrice;

  /// KO: 정액 할인 가격
  /// <br>
  /// EN: Fixed disount price
  final int? fixedDiscountPrice;

  /// KO: 할인율
  /// <br>
  /// EN: Discount rate
  final int? discountRate;

  /// KO: 상품 이름
  /// <br>
  /// EN: Product name
  final String? productName;

  /// KO: 화폐 단위
  /// <br>
  /// EN: Currency unit
  final String? currencyUnit;

  /// KO: 화폐 단위 표시 위치
  /// <br>
  /// EN: Position of currency unit
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
