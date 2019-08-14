import 'dart:async';

import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/src/common/api_factory.dart';
import 'package:kakao_flutter_sdk/src/push/model/push_token_info.dart';
import 'package:platform/platform.dart';

/// Provides Kakao Push API.
class PushApi {
  PushApi(this.dio, this.platform);
  final Dio dio;
  final Platform platform;

  static final instance = PushApi(ApiFactory.appKeyApi, LocalPlatform());

  Future<int> register(int uuid, String deviceId, String pushToken,
      {String pushType}) async {
    return ApiFactory.handleApiError(() async {
      final finalPushType = pushType ?? _detectPushType(platform);
      final data = {
        "uuid": uuid,
        "device_id": deviceId,
        "push_type": finalPushType,
        "push_token": pushToken
      };
      final response = await dio.post("/v1/push/register", data: data);
      return response.data;
    });
  }

  Future<void> deregister(int uuid, String deviceId, {String pushType}) async {
    return ApiFactory.handleApiError(() async {
      final finalPushType = pushType ?? _detectPushType(platform);
      final data = {
        "uuid": uuid,
        "device_id": deviceId,
        "push_type": finalPushType,
      };
      await dio.post("/v1/push/deregister", data: data);
    });
  }

  Future<List<PushTokenInfo>> tokens(int uuid) async {
    return ApiFactory.handleApiError(() async {
      final response =
          await dio.get("/v1/push/tokens", queryParameters: {"uuid": uuid});
      final data = response.data;
      return data is List
          ? data.map((e) => PushTokenInfo.fromJson(e)).toList()
          : throw KakaoClientException(
              "/v1/push/tokens response is not an array.");
    });
  }

  String _detectPushType(Platform platform) => platform.isAndroid
      ? "gcm"
      : (platform.isIOS || platform.isMacOS)
          ? "apns"
          : throw KakaoClientException(
              "Unsupported OS. Push API currently only supports gcm or apns");
}
