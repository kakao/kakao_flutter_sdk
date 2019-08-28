import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/local/model/coord.dart';
import 'package:kakao_flutter_sdk/src/local/model/count_meta.dart';
import 'package:kakao_flutter_sdk/src/local/model/local_search_meta.dart';
import 'package:kakao_flutter_sdk/src/local/model/place.dart';
import 'package:kakao_flutter_sdk/src/local/model/region.dart';
import 'package:kakao_flutter_sdk/src/local/model/total_address.dart';
import 'package:kakao_flutter_sdk/src/search/model/search_meta.dart';

class GenericsConverter<T> implements JsonConverter<T, Object> {
  const GenericsConverter();
  @override
  T fromJson(Object json) {
    if (T == SearchMeta) {
      return SearchMeta.fromJson(json as Map<String, dynamic>) as T;
    }
    if (T == CountMeta) {
      return CountMeta.fromJson(json as Map<String, dynamic>) as T;
    }
    if (T == LocalSearchMeta) {
      return LocalSearchMeta.fromJson(json as Map<String, dynamic>) as T;
    }
    if (T == TotalAddress) {
      return TotalAddress.fromJson(json as Map<String, dynamic>) as T;
    }
    if (T == Coord) {
      return Coord.fromJson(json as Map<String, dynamic>) as T;
    }
    if (T == Place) {
      return Place.fromJson(json as Map<String, dynamic>) as T;
    }
    if (T == Region) {
      return Region.fromJson(json as Map<String, dynamic>) as T;
    }
    return null;
  }

  @override
  Object toJson(T object) => object;
}
