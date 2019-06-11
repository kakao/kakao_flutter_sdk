import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/main.dart';
import 'package:kakao_flutter_sdk/src/talk/model/plus_friends_response.dart';
import 'package:kakao_flutter_sdk/src/talk/model/talk_profile.dart';

export 'package:kakao_flutter_sdk/src/talk/model/talk_profile.dart';

class TalkApi {
  TalkApi(this.dio);

  final Dio dio;

  static final TalkApi instance = TalkApi(ApiFactory.authApi);

  Future<TalkProfile> profile() async {
    return ApiFactory.handleApiError(() async {
      Response response = await dio.get("/v1/api/talk/profile",
          queryParameters: {"secure_resource": "true"});
      return TalkProfile.fromJson(response.data);
    });
  }

  Future<void> sendCustomMemo(
      int templateId, Map<String, String> templateArgs) async {
    return ApiFactory.handleApiError(() async {
      await dio.post("/v2/api/talk/memo/send", data: {});
    });
  }

  Future<void> sendDefaultMemo() async {
    return ApiFactory.handleApiError(() async {
      await dio.post("/v2/api/talk/memo/send", data: {});
    });
  }

  Future<void> sendScrapMemo() async {
    return ApiFactory.handleApiError(() async {
      await dio.post("/v2/api/talk/memo/send", data: {});
    });
  }

  Future<PlusFriendsResponse> plusFriends(List<String> publicIds) async {
    return ApiFactory.handleApiError(() async {
      Response response = await dio.get("/v2/api/talk/memo/send",
          queryParameters: {"plus_friend_public_ids": jsonEncode(publicIds)});
      return PlusFriendsResponse.fromJson(response.data);
    });
  }
}
