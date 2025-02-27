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
      if (instance.discountPrice case final value?) 'discount_price': value,
      if (instance.fixedDiscountPrice case final value?)
        'fixed_discount_price': value,
      if (instance.discountRate case final value?) 'discount_rate': value,
      if (instance.productName case final value?) 'product_name': value,
      if (instance.currencyUnit case final value?) 'currency_unit': value,
      if (instance.currencyUnitPosition case final value?)
        'currency_unit_position': value,
    };
