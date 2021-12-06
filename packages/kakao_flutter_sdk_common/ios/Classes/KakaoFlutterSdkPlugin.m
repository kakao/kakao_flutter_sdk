#import "KakaoFlutterSdkPlugin.h"
#import <kakao_flutter_sdk_common/kakao_flutter_sdk_common-Swift.h>

@implementation KakaoFlutterSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftKakaoFlutterSdkPlugin registerWithRegistrar:registrar];
}
@end
