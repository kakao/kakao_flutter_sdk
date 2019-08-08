// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commerce.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Commerce _$CommerceFromJson(Map<String, dynamic> json) {
  return Commerce(
    json['regular_price'] as int,
    discountPrice: json['discount_price'] as int,
    fixedDiscountPrice: json['fixed_discount_price'] as int,
    discountRate: json['discount_rate'] as int,
  );
}

Map<String, dynamic> _$CommerceToJson(Commerce instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('regular_price', instance.regularPrice);
  writeNotNull('discount_price', instance.discountPrice);
  writeNotNull('fixed_discount_price', instance.fixedDiscountPrice);
  writeNotNull('discount_rate', instance.discountRate);
  return val;
}
