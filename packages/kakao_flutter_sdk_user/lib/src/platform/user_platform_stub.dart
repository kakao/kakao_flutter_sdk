import '../user_platform.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';

/// @nodoc
class UserPlatformImpl extends UserPlatform {
  @override
  Future<int> selectShippingAddress({
    bool? mobileView,
    bool? enableBackButton,
  }) async {
    throw KakaoClientException.notSupported();
  }
}
