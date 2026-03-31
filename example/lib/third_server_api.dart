import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

// 웹 로그인 시 서버에서 토큰을 받아오는 예시 코드입니다. 실제로는 서비스 서버에서 토큰을 받아오도록 구현해야 합니다.
class ThirdServerApi {
  final String baseUrl;
  final Dio _dio;

  ThirdServerApi(this.baseUrl) : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<OAuthToken> getToken() async {
    var response = await _dio.get('/flutter/token/download');
    final tokenResponse = AccessTokenResponse.fromJson(response.data['token']);
    return OAuthToken.fromResponse(tokenResponse);
  }
}
