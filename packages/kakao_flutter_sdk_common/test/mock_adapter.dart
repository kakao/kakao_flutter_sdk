import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';

class MockAdapter extends HttpClientAdapter {
  late ResponseBody _responseBody;
  void Function(RequestOptions options)? requestAssertions;

  void setResponse(ResponseBody responseBody) {
    _responseBody = responseBody;
  }

  void setResponseString(String body, int statusCode) {
    _responseBody = ResponseBody.fromString(body, statusCode, headers: {
      HttpHeaders.contentTypeHeader: [ContentType.json.mimeType]
    });
  }

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<dynamic>? requestStream, Future<dynamic>? cancelFuture) async {
    if (requestAssertions != null) {
      requestAssertions!(options); // TODO: Function null safety not working?
    }
    return _responseBody;
  }

  @override
  void close({bool force = false}) {}
}
