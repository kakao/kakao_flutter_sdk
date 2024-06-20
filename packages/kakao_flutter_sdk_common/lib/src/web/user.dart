import 'package:kakao_flutter_sdk_common/src/kakao_sdk.dart';

String createSelectShippingAddressesUrl(final Map<String, dynamic> params) {
  return Uri.https(KakaoSdk.hosts.apps, '/user/address', params).toString();
}

String createKpidtUrl(final Map<String, dynamic> params) {
  return Uri.https(KakaoSdk.hosts.apps, '/auth/kpidt', params).toString();
}
