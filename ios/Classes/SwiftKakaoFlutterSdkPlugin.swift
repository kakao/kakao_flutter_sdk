import Flutter
import UIKit
import AuthenticationServices
import SafariServices

public class SwiftKakaoFlutterSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    NSLog("nslog register")
    let channel = FlutterMethodChannel(name: "kakao_flutter_sdk", binaryMessenger: registrar.messenger())
    let instance = SwiftKakaoFlutterSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getOrigin":
      result(origin())
    case "getKaHeader":
      result(kaHeader())
    case "launchWithBrowserTab":
        let args = call.arguments as! Dictionary<String, String>
        let url = args["url"]
        let redirectUri = args["redirect_uri"]
        launchWithBrowserTab(url: url!, redirectUri: redirectUri, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
    
    private func kaHeader() -> String {
        return "os/\(os()) lang/\(lang()) res/\(res()) device/\(device()) origin/\(origin()) app_ver/\(appVer())"
    }
    
    private func launchWithBrowserTab(url: String, redirectUri: String?, result: @escaping FlutterResult) {
        var keepMe: Any? = nil
        let completionHandler = { (url: URL?, err: Error?) in
            keepMe = nil

            if let err = err {
                if #available(iOS 12, *) {
                    if case ASWebAuthenticationSessionError.Code.canceledLogin = err {
                        result(FlutterError(code: "CANCELED", message: "User canceled login", details: nil))
                        return
                    }
                } else {
                    if case SFAuthenticationError.Code.canceledLogin = err {
                        result(FlutterError(code: "CANCELED", message: "User canceled login", details: nil))
                        return
                    }
                }
                result(FlutterError(code: "EUNKNOWN", message: err.localizedDescription, details: nil))
                return
            }
            result(url?.absoluteString)
        }
        let urlObject = URL(string: url)!
        let redirectUriObject: URL? = redirectUri == nil ? nil : URL(string: redirectUri!)
        if #available(iOS 12, *) {
            let session = ASWebAuthenticationSession(url: urlObject, callbackURLScheme: redirectUriObject?.scheme, completionHandler: completionHandler)
            session.start()
            keepMe = session
        } else {
            let session = SFAuthenticationSession(url: urlObject, callbackURLScheme: redirectUriObject?.scheme, completionHandler: completionHandler)
            session.start()
            keepMe = session
        }
    }
    
    private func os() -> String {
        return "ios-\(UIDevice.current.systemVersion)"
    }
    
    private func lang() -> String {
        return Locale.preferredLanguages.count > 0 ? Locale.preferredLanguages[0] : Locale.current.languageCode!
    }
    
    private func res() -> String {
        return "\(UIScreen.main.bounds.size.width)x\(UIScreen.main.bounds.size.height)"
    }
    
    private func device() -> String {
        return UIDevice.current.model
    }
    
    private func origin() -> String {
        return Bundle.main.bundleIdentifier!
    }
    
    private func appVer() -> String {
        return "0.1.0"
//        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
}
