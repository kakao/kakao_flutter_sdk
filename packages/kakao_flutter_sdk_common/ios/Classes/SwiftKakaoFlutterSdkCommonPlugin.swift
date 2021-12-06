import Flutter
import UIKit

public class SwiftKakaoFlutterSdkCommonPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "kakao_flutter_sdk_common", binaryMessenger: registrar.messenger())
    let instance = SwiftKakaoFlutterSdkCommonPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
