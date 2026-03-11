import 'platform/user_platform_stub.dart'
    if (dart.library.io) 'platform/user_platform_native.dart'
    if (dart.library.html) 'web/user_platform_web.dart';

/// @nodoc
abstract class UserPlatform {
  static final UserPlatform instance = UserPlatformImpl();

  Future<int> selectShippingAddress({bool? mobileView, bool? enableBackButton});
}
