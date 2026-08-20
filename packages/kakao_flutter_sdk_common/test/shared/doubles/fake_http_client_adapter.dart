import 'dart:typed_data';

import 'package:dio/dio.dart';

class FakeHttpClientAdapter implements HttpClientAdapter {
  bool mockFirstRequestFails = false;
  ResponseBody? mockResponse;
  ResponseBody? mockRetryResponse;
  int requestCount = 0;
  ResponseBody Function()? mockResponseCallback;
  Map<String, dynamic>? errorData;
  int? errorStatusCode;
  RequestOptions? lastRequestOptions;

  void setResponse(ResponseBody response) {}

  void mockInvalidTokenError() {
    errorData = {'msg': 'Invalid access token', 'code': -401, 'reason': 'ACCESS_TOKEN_EXPIRED'};
    errorStatusCode = 401;
  }

  void mockInsufficientScopeError(List<String> requiredScopes) {
    errorData = {
      'msg': 'Insufficient scope',
      'code': -402,
      'required_scopes': requiredScopes,
    };
    errorStatusCode = 403;
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestCount++;
    lastRequestOptions = options;

    if (mockResponseCallback != null) {
      return mockResponseCallback!();
    }

    // 첫 번째 요청이 실패하도록 설정된 경우
    if (mockFirstRequestFails && requestCount == 1) {
      if (errorData != null) {
        throw DioException(
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: errorStatusCode ?? 500,
            data: errorData,
          ),
          type: DioExceptionType.badResponse,
        );
      }
    }

    // 재시도 응답이 설정되어 있으면 반환
    if (requestCount > 1 && mockRetryResponse != null) {
      return mockRetryResponse!;
    }

    // 일반 응답 반환
    return mockResponse ??
        ResponseBody.fromString(
          '{"result": "success"}',
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
  }

  @override
  void close({bool force = false}) {}
}
