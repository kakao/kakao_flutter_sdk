import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';

class MockAdapter extends HttpClientAdapter {
  ResponseBody _responseBody;

  void setResponse(ResponseBody responseBody) {
    this._responseBody = responseBody;
  }

  void setResponseString(String body, int statusCode) {
    this._responseBody = ResponseBody.fromString(
        body,
        statusCode,
        DioHttpHeaders.fromMap(
            {HttpHeaders.contentTypeHeader: ContentType.json}));
  }

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<List<int>> requestStream, Future cancelFuture) async {
    return _responseBody;
  }
}
