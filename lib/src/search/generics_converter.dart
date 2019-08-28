import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/search/model/blog.dart';
import 'package:kakao_flutter_sdk/src/search/model/book.dart';
import 'package:kakao_flutter_sdk/src/search/model/cafe.dart';
import 'package:kakao_flutter_sdk/src/search/model/image_result.dart';
import 'package:kakao_flutter_sdk/src/search/model/tip.dart';
import 'package:kakao_flutter_sdk/src/search/model/vclip.dart';
import 'package:kakao_flutter_sdk/src/search/model/web_result.dart';

/// <nodoc>
class GenericsConverter<T> implements JsonConverter<T, Object> {
  const GenericsConverter();
  @override
  T fromJson(Object json) {
    if (T == WebResult) {
      return WebResult.fromJson(json as Map<String, dynamic>) as T;
    }
    if (T == VClip) {
      return VClip.fromJson(json as Map<String, dynamic>) as T;
    }
    if (T == ImageResult) {
      return ImageResult.fromJson(json as Map<String, dynamic>) as T;
    }
    if (T == Blog) {
      return Blog.fromJson(json as Map<String, dynamic>) as T;
    }
    if (T == Tip) {
      return Tip.fromJson(json as Map<String, dynamic>) as T;
    }
    if (T == Book) {
      return Book.fromJson(json as Map<String, dynamic>) as T;
    }
    if (T == Cafe) {
      return Cafe.fromJson(json as Map<String, dynamic>) as T;
    }
    return null;
  }

  @override
  Object toJson(T object) => object;
}
