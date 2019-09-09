import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk/common.dart';
import 'package:kakao_flutter_sdk/search.dart';
import 'package:kakao_flutter_sdk/src/local/model/coord.dart';
import 'package:kakao_flutter_sdk/src/local/model/count_meta.dart';
import 'package:kakao_flutter_sdk/src/local/model/local_envelope.dart';
import 'package:kakao_flutter_sdk/src/local/model/local_search_meta.dart';
import 'package:kakao_flutter_sdk/src/local/model/place.dart';
import 'package:kakao_flutter_sdk/src/local/model/region.dart';
import 'package:kakao_flutter_sdk/src/local/model/total_address.dart';
import 'package:kakao_flutter_sdk/src/search/model/search_meta.dart';

class LocalApi {
  LocalApi(this._dio);
  final Dio _dio;

  static final instance = LocalApi(ApiFactory.dapi);

  Future<LocalEnvelope<SearchMeta, TotalAddress>> address(String query,
      {int page, int size}) async {
    final params = {"query": query, "page": page, "size": size};
    return _localApi("/v2/local/search/address.json", params);
  }

  Future<LocalEnvelope<CountMeta, Region>> coord2Region(double x, double y,
      {CoordType inputCoord, CoordType outputCoord, String lang}) async {
    final params = {
      "x": x,
      "y": y,
      "input_coord": inputCoord == null ? null : describeEnum(inputCoord),
      "output_coord": outputCoord == null ? null : describeEnum(outputCoord),
      "lang": lang
    };
    return _localApi("/v2/local/geo/coord2regioncode.json", params);
  }

  Future<LocalEnvelope<CountMeta, TotalAddress>> coord2Address(
      double x, double y,
      {CoordType inputCoord}) async {
    final params = {
      "x": x,
      "y": y,
      "input_coord": inputCoord == null ? null : describeEnum(inputCoord)
    };
    return _localApi("/v2/local/geo/coord2address.json", params);
  }

  Future<LocalEnvelope<CountMeta, Coord>> transformCoord(
      double x, double y, CoordType outputCoord,
      {CoordType inputCoord}) async {
    final params = {
      "x": x,
      "y": y,
      "input_coord": inputCoord == null ? null : describeEnum(inputCoord),
      "output_coord": outputCoord == null ? null : describeEnum(outputCoord)
    };
    return _localApi("/v2/local/geo/transcoord.json", params);
  }

  Future<LocalEnvelope<LocalSearchMeta, Place>> placesWithKeyword(String query,
      {CategoryGroup categoryGroup,
      double x,
      double y,
      int radius,
      String rect,
      int page,
      int size,
      Order sort}) async {
    final params = {
      "query": query,
      "category_group_code":
          categoryGroup == null ? null : describeEnum(categoryGroup),
      "x": x,
      "y": y,
      "radius": radius,
      "rect": rect,
      "page": page,
      "size": size,
      "sort": sort == null ? null : describeEnum(sort).toLowerCase()
    };
    return _localApi("/v2/local/search/keyword.json", params);
  }

  Future<LocalEnvelope<LocalSearchMeta, Place>> placesWithCategory(
      CategoryGroup categoryGroup,
      {double x,
      double y,
      int radius,
      String rect,
      int page,
      int size,
      Order sort}) async {
    final params = {
      "category_group_code":
          categoryGroup == null ? null : describeEnum(categoryGroup),
      "x": x,
      "y": y,
      "radius": radius,
      "rect": rect,
      "page": page,
      "size": size,
      "sort": sort == null ? null : describeEnum(sort).toLowerCase()
    };
    return _localApi("/v2/local/search/category.json", params);
  }

  Future<LocalEnvelope<T, U>> _localApi<T, U>(
      String path, Map<String, dynamic> params) {
    return ApiFactory.handleApiError(() async {
      params.removeWhere((k, v) => v == null);
      final response = await _dio.get(path, queryParameters: params);
      return LocalEnvelope<T, U>.fromJson(response.data);
    });
  }
}

enum Order { DISTANCE, ACCURACY }
