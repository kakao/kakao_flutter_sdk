#import "KakaoFlutterSdkPlugin.h"
#import <kakao_flutter_sdk/kakao_flutter_sdk-Swift.h>

@implementation KakaoFlutterSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftKakaoFlutterSdkPlugin registerWithRegistrar:registrar];
}
@end
