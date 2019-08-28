// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) {
  return Book(
    json['title'] as String,
    json['contents'] as String,
    json['url'] == null ? null : Uri.parse(json['url'] as String),
    json['datetime'] == null
        ? null
        : DateTime.parse(json['datetime'] as String),
    json['thumbnail'] == null ? null : Uri.parse(json['thumbnail'] as String),
    json['isbn'] as String,
    (json['authors'] as List)?.map((e) => e as String)?.toList(),
    json['publisher'] as String,
    (json['translators'] as List)?.map((e) => e as String)?.toList(),
    json['price'] as int,
    json['sale_price'] as int,
    json['status'] as String,
  );
}

Map<String, dynamic> _$BookToJson(Book instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('title', instance.title);
  writeNotNull('contents', instance.contents);
  writeNotNull('url', instance.url?.toString());
  writeNotNull('datetime', instance.datetime?.toIso8601String());
  writeNotNull('thumbnail', instance.thumbnail?.toString());
  writeNotNull('isbn', instance.isbn);
  writeNotNull('authors', instance.authors);
  writeNotNull('publisher', instance.publisher);
  writeNotNull('translators', instance.translators);
  writeNotNull('price', instance.price);
  writeNotNull('sale_price', instance.salePrice);
  writeNotNull('status', instance.status);
  return val;
}
