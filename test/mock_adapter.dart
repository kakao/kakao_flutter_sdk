import 'dart:async';
import 'package:dio/dio.dart';

class MockAdapter extends HttpClientAdapter {
  ResponseBody _responseBody;

  void setResponse(ResponseBody responseBody) {
    this._responseBody = responseBody;
  }

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<List<int>> requestStream, Future cancelFuture) async {
    return _responseBody;
  }
}
