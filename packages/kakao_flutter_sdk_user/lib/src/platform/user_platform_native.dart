import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';

import '../constants.dart';
import '../user_platform.dart';

/// @nodoc
class UserPlatformImpl extends UserPlatform {

  @override
  Future<int> selectShippingAddress({
    bool? mobileView, // web only
    bool? enableBackButton, // web only
  }) async {
    await AuthApi.instance.refreshToken();

    final agt = await AuthApi.instance.agt();

    final params = <String, String>{
      Constants.appKey: KakaoSdk.appKey,
      Constants.ka: KakaoSdk.platformInfo.kaHeader,
      Constants.returnUrl:
          '${KakaoSdk.customScheme}://${Constants.shippingAddressesScheme}',
      Constants.enableBackButton: false.toString(),
    };

    final continueUrl = Uri(
      scheme: 'https',
      host: KakaoSdk.hosts.apps,
      path: Constants.selectShippingAddressPath,
      query: params.toQuery(),
    ).toString();

    final appsParams = <String, String>{
      Constants.appKey: KakaoSdk.appKey,
      Constants.agt: agt,
      Constants.continueUrl: continueUrl.toString(),
    };
    final url = Uri(
      scheme: 'https',
      host: KakaoSdk.hosts.apps,
      path: Constants.kpidtPath,
      query: appsParams.toQuery(),
    ).toString();

    final result = await AuthPlatform.instance.handleAppsUrl(url);
    final resultUri = Uri.parse(result);

    if (resultUri.queryParameters[Constants.status] == Constants.error) {
      throw KakaoAppsException.fromJson(resultUri.queryParameters);
    }
    return int.parse(resultUri.queryParameters[Constants.addressId]!);
  }
}
