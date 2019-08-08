import Flutter
import UIKit
import AuthenticationServices
import SafariServices

public class SwiftKakaoFlutterSdkPlugin: NSObject, FlutterPlugin {
    public var result: FlutterResult? = nil
    public var redirectUri: String? = nil
    var authorizeTalkCompletionHandler : ((URL?, String?) -> Void)?

  public static func register(with registrar: FlutterPluginRegistrar) {
    NSLog("nslog register")
    let channel = FlutterMethodChannel(name: "kakao_flutter_sdk", binaryMessenger: registrar.messenger())
    let instance = SwiftKakaoFlutterSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.addApplicationDelegate(instance)
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
    case "authorizeWithTalk":
        let args = call.arguments as! Dictionary<String, String>
        authorizeWithTalk(clientId: args["client_id"]!, redirectUri: args["redirect_uri"]!, result: result)
        
    default:
      result(FlutterMethodNotImplemented)
    }
  }
    
    private func kaHeader() -> String {
        return "os/\(os()) lang/\(lang()) res/\(res()) device/\(device()) origin/\(origin()) app_ver/\(appVer())"
    }
    
    private func makeUrlStringWithParameters(_ url:String, parameters:[String:String]) -> String? {
        guard var components = URLComponents(string:url) else { return nil }
        components.queryItems = parameters.map { URLQueryItem(name: $0.0, value: $0.1)}
        return components.url?.absoluteString
    }
    
    private func makeUrlWithParameters(_ url:String, parameters:[String:String]) -> URL? {
        guard let finalStringUrl = makeUrlStringWithParameters(url, parameters:parameters) else { return nil }
        return URL(string:finalStringUrl)
    }

    
    private func authorizeWithTalk(clientId: String, redirectUri: String, result: @escaping FlutterResult) {
        self.result = result
        self.redirectUri = redirectUri
        
        self.authorizeTalkCompletionHandler = {
            (callbackUrl:URL?, error: String?) in
            
            guard error == nil else {
                //TODO:error wrapping check
                result(FlutterError(code: "No callback url", message: "authorize with talk error: \n -> where is callbackUrl?", details: nil))
                return
            }
            
            guard let callbackUrl = callbackUrl else {
                //TODO:error type check
                result(FlutterError(code: "No callback url", message: "No callback url", details: nil))
                return
            }
            result(callbackUrl.absoluteString)
            return
        }
        var parameters = [String:String]()
        parameters["client_id"] = clientId
        parameters["redirect_uri"] = redirectUri
        parameters["response_type"] = "code"

        guard let url = makeUrlWithParameters("kakaokompassauth://authorize", parameters: parameters) else {
            result(FlutterError(code: "makeURL", message: "makeUrlWithParameters failed", details: nil))
            return
        }

        UIApplication.shared.open(url, options: [:]) { (openResult) in
            if (!openResult) {
                result(FlutterError(code: "UIApplication.open() failed", message: "UIApplication.open() failed", details: nil))
            }
        }
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
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let finalRedirectUri = self.redirectUri else {
            self.authorizeTalkCompletionHandler?(nil, "final redirectUri nil...")
            return true
        }
        if (url.absoluteString.hasPrefix(finalRedirectUri)) {
            self.authorizeTalkCompletionHandler?(url, nil)
            return true
        }
        self.authorizeTalkCompletionHandler?(nil, "redirectUri mismatch...")
        return true
    }
}
