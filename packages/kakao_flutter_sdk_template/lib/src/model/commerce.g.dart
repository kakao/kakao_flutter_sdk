// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commerce.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Commerce _$CommerceFromJson(Map<String, dynamic> json) {
  return Commerce(
    json['regular_price'] as int,
    discountPrice: json['discount_price'] as int?,
    fixedDiscountPrice: json['fixed_discount_price'] as int?,
    discountRate: json['discount_rate'] as int?,
    productName: json['product_name'] as String?,
    currencyUnit: json['currency_unit'] as String?,
    currencyUnitPosition: json['currency_unit_position'] as int?,
  );
}

Map<String, dynamic> _$CommerceToJson(Commerce instance) {
  final val = <String, dynamic>{
    'regular_price': instance.regularPrice,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('discount_price', instance.discountPrice);
  writeNotNull('fixed_discount_price', instance.fixedDiscountPrice);
  writeNotNull('discount_rate', instance.discountRate);
  writeNotNull('product_name', instance.productName);
  writeNotNull('currency_unit', instance.currencyUnit);
  writeNotNull('currency_unit_position', instance.currencyUnitPosition);
  return val;
}
