#import "KakaoFlutterSdkPlugin.h"
#if __has_include(<kakao_flutter_sdk_common/kakao_flutter_sdk_common-Swift.h>)
#import <kakao_flutter_sdk_common/kakao_flutter_sdk_common-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "kakao_flutter_sdk_common-Swift.h"
#endif

@implementation KakaoFlutterSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftKakaoFlutterSdkPlugin registerWithRegistrar:registrar];
}
@end
