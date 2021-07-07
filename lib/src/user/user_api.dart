import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/src/common/api_factory.dart';

import 'model/access_token_info.dart';
import 'model/shipping_addresses.dart';
import 'model/user.dart';
import 'model/user_id_response.dart';
import 'model/user_service_terms.dart';

/// Provides User API.
class UserApi {
  UserApi(this._dio);

  final Dio _dio;

  /// default instance SDK provides.
  static final UserApi instance = UserApi(ApiFactory.authApi);

  /// Login with KakaoTalk.
  /// Authenticate the user with a Kakao account connected to KakaoTalk and issue OAuthToken
  Future<void> loginWithKakaoTalk() async {
    final authCode = await AuthCodeClient.instance.requestWithTalk();
    final token = await AuthApi.instance.issueAccessToken(authCode);
    await AccessTokenStore.instance.toStore(token);
  }

  /// Login with KakaoAccount.
  /// Authenticate the user with a Kakao account cookie in default web browser(CustomTabs) and issue OAuthToken
  Future<void> loginWithKakaoAccount() async {
    final authCode = await AuthCodeClient.instance.request();
    final token = await AuthApi.instance.issueAccessToken(authCode);
    await AccessTokenStore.instance.toStore(token);
  }

  /// Displays a consent screen requesting consent for personal information and access rights consent items that the user has not yet agreed to,
  /// and issues an updated OAuthToken with the consent items when the user agrees.
  Future<void> loginWithNewScopes(List<String> scopes) async {
    final authCode = await AuthCodeClient.instance.requestWithAgt(scopes);
    final token = await AuthApi.instance.issueAccessToken(authCode);
    await AccessTokenStore.instance.toStore(token);
  }

  /// Fetches current user's information.
  Future<User> me() async {
    return ApiFactory.handleApiError(() async {
      Response response = await _dio
          .get("/v2/user/me", queryParameters: {"secure_resource": true});
      return User.fromJson(response.data);
    });
  }

  /// Invalidates current user's access token and refresh token.
  Future<UserIdResponse> logout() async {
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.post("/v1/user/logout");
      return UserIdResponse.fromJson(response.data);
    });
  }

  /// Unlinks current user from the app.
  Future<UserIdResponse> unlink() async {
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.post("/v1/user/unlink");
      return UserIdResponse.fromJson(response.data);
    });
  }

  /// Fetches accurate access token information from Kakao API server.
  ///
  /// Token infomration on client side cannot be trusted since it could be expired at any time on server side.
  ///
  /// - User changes Kakao account password and invalidates tokens
  /// - User unlinks from the application
  ///
  ///
  Future<AccessTokenInfo> accessTokenInfo() async {
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.get("/v1/user/access_token_info");
      return AccessTokenInfo.fromJson(response.data);
    });
  }

  /// Fetches current user's shipping addresses stored in Kakao account.
  Future<ShippingAddresses> shippingAddresses() async {
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.get("/v1/user/shipping_address");
      return ShippingAddresses.fromJson(response.data);
    });
  }

  /// Fetches a list of custom service terms that current user has agreed to.
  Future<UserServiceTerms> serviceTerms() async {
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.get("/v1/user/service/terms");
      return UserServiceTerms.fromJson(response.data);
    });
  }

  /// Save or modify user's additional information provided in User class.
  ///
  /// Check the savable key name in Kakao Developers > Kakao Login > User Properties menu.
  /// The nickname, profile_image, and thumbnail_image values ​​that are saved by default when connecting the app can be overwritten,
  /// and information can be saved with the key name by adding a new column.
  Future<void> updateProfile(Map<String, String> properties) {
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.post('/v1/user/update_profile',
          data: {'properties': jsonEncode(properties)});
      print(response);
    });
  }

  /// Request app connection for user with app connection status **PREREGISTER**. **Auto Link** Used by apps with disabled settings.
  Future<void> signup({Map<String, String>? properties}) {
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.post('/v1/user/signup',
          data: {'properties': jsonEncode(properties)});
      print(response);
    });
  }
}
