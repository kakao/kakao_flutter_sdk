import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/main.dart';
import 'package:kakao_flutter_sdk/src/talk/model/plus_friends_response.dart';
import 'package:kakao_flutter_sdk/src/talk/model/talk_profile.dart';
import 'package:kakao_flutter_sdk/src/template/default_template.dart';

export 'package:kakao_flutter_sdk/src/talk/model/talk_profile.dart';
export 'package:kakao_flutter_sdk/src/template/default_template.dart';

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

  Future<void> customMemo(int templateId,
      [Map<String, String> templateArgs]) async {
    return _memo("", {
      "template_id": templateId,
      ...(templateArgs == null
          ? {}
          : {"template_args": jsonEncode(templateArgs)})
    });
  }

  Future<void> defaultMemo(DefaultTemplate template) async {
    return _memo("default/", {"template_object": jsonEncode(template)});
  }

  Future<void> scrapMemo(String url,
      {int templateId, Map<String, String> templateArgs}) async {
    return _memo("scra/", {
      "request_url": url,
      ...(templateId == null ? {} : {"template_id": templateId}),
      ...(templateArgs == null ? {} : {"template_args": templateArgs})
    });
  }

  Future<void> _memo(String pathPart, Map<String, dynamic> params) async {
    return ApiFactory.handleApiError(() async {
      await dio.post("/v2/api/talk/memo/${pathPart}send", data: params);
    });
  }

  Future<PlusFriendsResponse> plusFriends([List<String> publicIds]) async {
    return ApiFactory.handleApiError(() async {
      Response response = await dio.get("/v2/api/talk/memo/send",
          queryParameters: publicIds == null
              ? {}
              : {"plus_friend_public_ids": jsonEncode(publicIds)});
      return PlusFriendsResponse.fromJson(response.data);
    });
  }
}
