import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/common.dart';
import 'package:kakao_flutter_sdk/src/search/model/blog.dart';
import 'package:kakao_flutter_sdk/src/search/model/book.dart';
import 'package:kakao_flutter_sdk/src/search/model/cafe.dart';
import 'package:kakao_flutter_sdk/src/search/model/image_result.dart';
import 'package:kakao_flutter_sdk/src/search/model/search_envelope.dart';
import 'package:kakao_flutter_sdk/src/search/model/tip.dart';
import 'package:kakao_flutter_sdk/src/search/model/vclip.dart';
import 'package:kakao_flutter_sdk/src/search/model/web_result.dart';

@Deprecated(
    "These APIs will be removed when version 1.0.0 is released. If you want to use it, use REST API.")
class SearchApi {
  SearchApi(this._dio);

  final Dio _dio;

  static final instance = SearchApi(ApiFactory.dapi);

  Future<SearchEnvelope<WebResult>> web(String query,
      {Order? sort, int? page, int? size}) async {
    return ApiFactory.handleApiError(() async {
      final response = await _dio.get("/v2/search/web",
          queryParameters: _getParams(query, sort, page, size));
      return SearchEnvelope<WebResult>.fromJson(response.data);
    });
  }

  Future<SearchEnvelope<VClip>> vclip(String query,
      {Order? sort, int? page, int? size}) async {
    return ApiFactory.handleApiError(() async {
      final response = await _dio.get("/v2/search/vclip",
          queryParameters: _getParams(query, sort, page, size));
      return SearchEnvelope<VClip>.fromJson(response.data);
    });
  }

  Future<SearchEnvelope<ImageResult>> image(String query,
      {Order? sort, int? page, int? size}) async {
    return ApiFactory.handleApiError(() async {
      final response = await _dio.get("/v2/search/image",
          queryParameters: _getParams(query, sort, page, size));
      return SearchEnvelope<ImageResult>.fromJson(response.data);
    });
  }

  Future<SearchEnvelope<Blog>> blog(String query,
      {Order? sort, int? page, int? size}) async {
    return ApiFactory.handleApiError(() async {
      final response = await _dio.get("/v2/search/blog",
          queryParameters: _getParams(query, sort, page, size));
      return SearchEnvelope<Blog>.fromJson(response.data);
    });
  }

  Future<SearchEnvelope<Tip>> tip(String query,
      {Order? sort, int? page, int? size}) async {
    return ApiFactory.handleApiError(() async {
      final response = await _dio.get("/v2/search/tip",
          queryParameters: _getParams(query, sort, page, size));
      return SearchEnvelope<Tip>.fromJson(response.data);
    });
  }

  Future<SearchEnvelope<Book>> book(String query,
      {Order? sort, int? page, int? size, BookTarget? target}) async {
    return ApiFactory.handleApiError(() async {
      final response = await _dio.get("/v3/search/book", queryParameters: {
        ..._getParams(query, sort, page, size),
        "target": target == null ? null : describeEnum(target).toLowerCase()
      });
      return SearchEnvelope<Book>.fromJson(response.data);
    });
  }

  Future<SearchEnvelope<Cafe>> cafe(String query,
      {Order? sort, int? page, int? size}) async {
    return ApiFactory.handleApiError(() async {
      final response = await _dio.get("/v2/search/cafe",
          queryParameters: _getParams(query, sort, page, size));
      return SearchEnvelope<Cafe>.fromJson(response.data);
    });
  }

  Map<String, dynamic> _getParams(
      String? query, Order? sort, int? page, int? size) {
    final params = {
      "query": query,
      "sort": sort == null ? null : describeEnum(sort).toLowerCase(),
      "page": page,
      "size": size
    };
    params.removeWhere((k, v) => v == null);
    return params;
  }
}

enum Order {
  @JsonValue("accuracy")
  ACCURACY,
  @JsonValue("latest")
  LATEST
}
enum BookTarget {
  @JsonValue("title")
  TITLE,
  @JsonValue("isbn")
  ISBN,
  @JsonValue("publisher")
  PUBLISHER,
  @JsonValue("person")
  PERSON
}
