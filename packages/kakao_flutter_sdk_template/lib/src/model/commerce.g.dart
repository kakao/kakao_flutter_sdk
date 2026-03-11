// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commerce.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Commerce _$CommerceFromJson(Map<String, dynamic> json) => Commerce(
  regularPrice: (json['regular_price'] as num).toInt(),
  discountPrice: (json['discount_price'] as num?)?.toInt(),
  fixedDiscountPrice: (json['fixed_discount_price'] as num?)?.toInt(),
  discountRate: (json['discount_rate'] as num?)?.toInt(),
  productName: json['product_name'] as String?,
  currencyUnit: json['currency_unit'] as String?,
  currencyUnitPosition: (json['currency_unit_position'] as num?)?.toInt(),
);

Map<String, dynamic> _$CommerceToJson(Commerce instance) => <String, dynamic>{
  'regular_price': instance.regularPrice,
  'discount_price': ?instance.discountPrice,
  'fixed_discount_price': ?instance.fixedDiscountPrice,
  'discount_rate': ?instance.discountRate,
  'product_name': ?instance.productName,
  'currency_unit': ?instance.currencyUnit,
  'currency_unit_position': ?instance.currencyUnitPosition,
};
