import 'dart:async';
import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/src/common/api_factory.dart';

import 'model/access_token_info.dart';
import 'model/service_terms.dart';
import 'model/shipping_addresses.dart';
import 'model/user_id_response.dart';
import 'model/user.dart';

/// Provides User API.
class UserApi {
  UserApi(this._dio);

  final Dio _dio;

  /// default instance SDK provides.
  static final UserApi instance = UserApi(ApiFactory.authApi);

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
  Future<ServiceTerms> serviceTerms() async {
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.get("/v1/user/service/terms");
      return ServiceTerms.fromJson(response.data);
    });
  }
}
