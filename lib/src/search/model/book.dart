import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/search/model/thumbnail_result.dart';

part 'book.g.dart';

/// Book searched with K
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Book extends ThumbnailResult {
  Book(
      String title,
      String contents,
      Uri url,
      DateTime datetime,
      Uri thumbnail,
      this.isbn,
      this.authors,
      this.publisher,
      this.translators,
      this.price,
      this.salePrice,
      this.status)
      : super(title, contents, url, datetime, thumbnail);

  String isbn;
  List<String> authors;
  String publisher;
  List<String> translators;

  /// regular price
  int price;

  /// actual sale price
  int salePrice;

  /// Sales status (such as normal, sold out, discontinued)
  /// Use this only for display purpose, not as an enum.
  String status;

  /// <nodoc>
  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$BookToJson(this);

  @override
  String toString() => toJson().toString();
}
