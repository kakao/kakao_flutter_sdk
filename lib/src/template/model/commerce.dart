import 'package:json_annotation/json_annotation.dart';

part 'commerce.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Commerce {
  Commerce(this.regularPrice,
      {this.discountPrice, this.fixedDiscountPrice, this.discountRate});

  final int regularPrice;
  final int discountPrice;
  final int fixedDiscountPrice;
  final int discountRate;

  factory Commerce.fromJson(Map<String, dynamic> json) =>
      _$CommerceFromJson(json);
  Map<String, dynamic> toJson() => _$CommerceToJson(this);
}
