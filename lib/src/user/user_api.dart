import 'dart:async';
import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/src/api_factory.dart';

import 'model/access_token_info.dart';
import 'model/service_terms.dart';
import 'model/shipping_addresses.dart';
import 'model/user_id_response.dart';
import 'model/user.dart';

export 'model/user.dart';
export 'model/access_token_info.dart';
export 'model/shipping_address.dart';
export 'model/shipping_addresses.dart';
export 'model/service_terms.dart';
export 'model/user_id_response.dart';

class UserApi {
  UserApi(this.dio);

  final Dio dio;

  static final UserApi instance = UserApi(ApiFactory.authApi);

  Future<User> me() async {
    return ApiFactory.handleApiError(() async {
      Response response = await dio.get("/v2/user/me");
      return User.fromJson(response.data);
    });
  }

  Future<UserIdResponse> logout() async {
    return ApiFactory.handleApiError(() async {
      Response response = await dio.post("/v1/user/logout");
      return UserIdResponse.fromJson(response.data);
    });
  }

  Future<UserIdResponse> unlink() async {
    return ApiFactory.handleApiError(() async {
      Response response = await dio.post("/v1/user/unlink");
      return UserIdResponse.fromJson(response.data);
    });
  }

  Future<AccessTokenInfo> accessTokenInfo() async {
    return ApiFactory.handleApiError(() async {
      Response response = await dio.get("/v1/user/access_token_info");
      return AccessTokenInfo.fromJson(response.data);
    });
  }

  Future<ShippingAddresses> shippingAddresses() async {
    return ApiFactory.handleApiError(() async {
      Response response = await dio.get("/v1/user/shipping_addresses");
      return ShippingAddresses.fromJson(response.data);
    });
  }

  Future<ServiceTerms> serviceTerms() async {
    return ApiFactory.handleApiError(() async {
      Response response = await dio.get("/v1/user/service/terms");
      return ServiceTerms.fromJson(response.data);
    });
  }
}
