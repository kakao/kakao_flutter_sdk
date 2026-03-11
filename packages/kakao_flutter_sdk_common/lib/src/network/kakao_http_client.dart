/// @nodoc
abstract class KakaoHttpClient {
  Future<KakaoResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<KakaoResponse> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<KakaoResponse> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<KakaoResponse> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });
}

/// @nodoc
class KakaoResponse {
  final int statusCode;
  final dynamic data;
  final Map<String, List<String>> headers;

  KakaoResponse({
    required this.statusCode,
    required this.data,
    required this.headers,
  });

  @override
  String toString() {
    return 'KakaoResponse{statusCode: $statusCode, data: $data, headers: $headers}';
  }
}
