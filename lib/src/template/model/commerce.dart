import 'package:json_annotation/json_annotation.dart';

part 'commerce.g.dart';

/// Represents commerce section data of commerce type template.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Commerce {
  final int regularPrice;
  final int? discountPrice;

  /// exclusive with [discountRate].
  final int? fixedDiscountPrice;

  /// exclusive with [fixedDiscountPrice].
  final int? discountRate;

  final String? productName;
  final String? currencyUnit;
  final int? currencyUnitPosition;

  /// <nodoc>
  Commerce(this.regularPrice,
      {this.discountPrice,
      this.fixedDiscountPrice,
      this.discountRate,
      this.productName,
      this.currencyUnit,
      this.currencyUnitPosition});

  /// <nodoc>
  factory Commerce.fromJson(Map<String, dynamic> json) =>
      _$CommerceFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$CommerceToJson(this);
}
