import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk/src/search/search_api.dart';

import '../helper.dart';
import '../mock_adapter.dart';

void main() {
  MockAdapter _adapter;
  SearchApi _api;
  Dio _dio;

  setUp(() {
    _dio = Dio();
    _adapter = MockAdapter();
    _dio.httpClientAdapter = _adapter;
    _api = SearchApi(_dio);
  });

  group('/all', () {
    test("web", () async {
      final body = await loadJson("search/web.json");
      final map = jsonDecode(body);

      _adapter.requestAssertions = (RequestOptions options) {
        final params = options.queryParameters;
        expect(params["sort"], "accuracy");
        expect(params["query"], "query");
        expect(params["page"], 2);
        expect(params["size"], 10);
      };
      _adapter.setResponseString(body, 200);
      final result =
          await _api.web("query", sort: Order.ACCURACY, page: 2, size: 10);

      expect(result.meta.totalCount, map["meta"]["total_count"]);
      expect(result.meta.pageableCount, map["meta"]["pageable_count"]);
      expect(result.meta.isEnd, map["meta"]["is_end"]);

      final documents = map["documents"];
      result.documents.asMap().forEach((index, actual) {
        Map<String, dynamic> expected = documents[index];
        expect(actual.title, expected["title"]);
        expect(actual.url.toString(), expected["url"]);
        expect(actual.contents, expected["contents"]);
        // expect(
        //     expected["datetime"]
        //         .startsWith(actual.datetime.toLocal().toIso8601String()),
        //     true);
      });

      result.toString();
    });

    test("/vclip", () async {
      final body = await loadJson("search/vclip.json");
      final map = jsonDecode(body);

      _adapter.requestAssertions = (RequestOptions options) {
        final params = options.queryParameters;
        expect(params["sort"], "latest");
      };
      _adapter.setResponseString(body, 200);
      final result = await _api.vclip("query", sort: Order.LATEST);

      final documents = map["documents"];
      result.documents.asMap().forEach((index, actual) {
        final expected = documents[index];
        expect(actual.title, expected["title"]);
        expect(actual.url.toString(), expected["url"]);
        expect(actual.playTime, expected["play_time"]);
        expect(actual.author, expected["author"]);
        expect(actual.thumbnail.toString(), expected["thumbnail"]);
      });
      result.toString();
    });

    test("/image", () async {
      final body = await loadJson("search/image.json");
      final map = jsonDecode(body);
      _adapter.setResponseString(body, 200);
      final result = await _api.image("query");

      final documents = map["documents"];
      result.documents.asMap().forEach((index, actual) {
        final expected = documents[index];
        expect(actual.collection, expected["collection"]);
        expect(actual.thumbnailUrl.toString(), expected["thumbnail_url"]);
        expect(actual.imageUrl.toString(), expected["image_url"]);
        expect(actual.width, expected["width"]);
        expect(actual.height, expected["height"]);
        expect(actual.displaySitename, expected["display_sitename"]);
        expect(actual.docUrl.toString(), expected["doc_url"]);
      });
      result.toString();
    });

    test("/blog", () async {
      final body = await loadJson("search/blog.json");
      final map = jsonDecode(body);
      _adapter.setResponseString(body, 200);
      final result = await _api.blog("query");

      final documents = map["documents"];
      result.documents.asMap().forEach((index, actual) {
        final expected = documents[index];
        expect(actual.title, expected["title"]);
        expect(actual.contents, expected["contents"]);
        expect(actual.url.toString(), expected["url"]);
        expect(actual.thumbnail.toString(), expected["thumbnail"]);
        expect(actual.blogName, expected["blogname"]);
      });
      result.toString();
    });

    test("/tip", () async {
      final body = await loadJson("search/tip.json");
      final map = jsonDecode(body);
      _adapter.setResponseString(body, 200);
      final result = await _api.tip("query");

      final documents = map["documents"];
      result.documents.asMap().forEach((index, actual) {
        final expected = documents[index];
        expect(actual.title, expected["title"]);
        expect(actual.contents, expected["contents"]);
        expect(actual.questionUrl.toString(), expected["q_url"]);
        expect(actual.answerUrl.toString(), expected["a_url"]);
        expect(actual.type, expected["type"]);
      });
      result.toString();
    });

    test("/book", () async {
      final body = await loadJson("search/book.json");
      final map = jsonDecode(body);
      _adapter.setResponseString(body, 200);
      final result = await _api.book("query");

      final documents = map["documents"];
      result.documents.asMap().forEach((index, actual) {
        final expected = documents[index];
        expect(actual.title, expected["title"]);
        expect(actual.contents, expected["contents"]);
        expect(actual.url.toString(), expected["url"]);
        expect(actual.thumbnail.toString(), expected["thumbnail"]);
        expect(actual.isbn, expected["isbn"]);
        expect(actual.publisher, expected["publisher"]);
        expect(actual.price, expected["price"]);
        expect(actual.salePrice, expected["sale_price"]);
        expect(actual.status, expected["status"]);
      });
      result.toString();
    });

    test("/cafe", () async {
      final body = await loadJson("search/cafe.json");
      final map = jsonDecode(body);
      _adapter.setResponseString(body, 200);
      final result = await _api.cafe("query");

      final documents = map["documents"];
      result.documents.asMap().forEach((index, actual) {
        final expected = documents[index];
        expect(actual.title, expected["title"]);
        expect(actual.contents, expected["contents"]);
        expect(actual.url.toString(), expected["url"]);
        expect(actual.thumbnail.toString(), expected["thumbnail"]);
        expect(actual.cafeName, expected["cafename"]);
      });
      result.toString();
    });
  });
}
