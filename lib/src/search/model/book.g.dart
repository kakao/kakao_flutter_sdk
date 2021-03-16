// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) {
  return Book(
    json['title'] as String,
    json['contents'] as String,
    Uri.parse(json['url'] as String),
    DateTime.parse(json['datetime'] as String),
    Uri.parse(json['thumbnail'] as String),
    json['isbn'] as String,
    (json['authors'] as List<dynamic>).map((e) => e as String).toList(),
    json['publisher'] as String,
    (json['translators'] as List<dynamic>).map((e) => e as String).toList(),
    json['price'] as int,
    json['sale_price'] as int,
    json['status'] as String,
  );
}

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
      'title': instance.title,
      'contents': instance.contents,
      'url': instance.url.toString(),
      'datetime': instance.datetime.toIso8601String(),
      'thumbnail': instance.thumbnail.toString(),
      'isbn': instance.isbn,
      'authors': instance.authors,
      'publisher': instance.publisher,
      'translators': instance.translators,
      'price': instance.price,
      'sale_price': instance.salePrice,
      'status': instance.status,
    };
