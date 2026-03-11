import 'dart:async';

import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

class KakaoRequest {
  KakaoRequest({
    required this.method,
    required this.path,
    this.data,
    this.queryParameters,
    this.headers,
  });

  final String method;
  final String path;
  final Object? data;
  final Map<String, dynamic>? queryParameters;
  final Map<String, dynamic>? headers;
}

class TestKakaoHttpClient implements KakaoHttpClient {
  TestKakaoHttpClient({KakaoResponseHandler? handler}) : _handler = handler;

  final KakaoResponseHandler? _handler;
  final List<KakaoRequest> requests = [];
  final List<KakaoResponse> _responses = [];

  KakaoRequest get lastRequest => requests.last;

  void enqueueJson(
    Map<String, dynamic> data, {
    int statusCode = 200,
    Map<String, List<String>> headers = const {},
  }) {
    _responses.add(
      KakaoResponse(statusCode: statusCode, data: data, headers: headers),
    );
  }

  @override
  Future<KakaoResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _handle(
      'GET',
      path,
      data: null,
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  @override
  Future<KakaoResponse> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _handle(
      'POST',
      path,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  @override
  Future<KakaoResponse> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _handle(
      'PUT',
      path,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  @override
  Future<KakaoResponse> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _handle(
      'DELETE',
      path,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  Future<KakaoResponse> _handle(
    String method,
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    requests.add(
      KakaoRequest(
        method: method,
        path: path,
        data: data,
        queryParameters: queryParameters,
        headers: headers,
      ),
    );

    if (_handler != null) {
      return await _handler(lastRequest);
    }

    if (_responses.isEmpty) {
      throw StateError('TestKakaoHttpClient has no queued responses.');
    }

    return _responses.removeAt(0);
  }
}

typedef KakaoResponseHandler =
    FutureOr<KakaoResponse> Function(KakaoRequest request);
