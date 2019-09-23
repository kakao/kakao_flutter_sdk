import Flutter
import UIKit
import AuthenticationServices
import SafariServices

public class SwiftKakaoFlutterSdkPlugin: NSObject, FlutterPlugin, ASWebAuthenticationPresentationContextProviding {
    var result: FlutterResult? = nil
    var redirectUri: String? = nil
    var authorizeTalkCompletionHandler : ((URL?, FlutterError?) -> Void)?

  public static func register(with registrar: FlutterPluginRegistrar) {
    NSLog("nslog register")
    let channel = FlutterMethodChannel(name: "kakao_flutter_sdk", binaryMessenger: registrar.messenger())
    let instance = SwiftKakaoFlutterSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.addApplicationDelegate(instance) // This is necessary to receive open iurl delegate method.
  }
    
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getOrigin":
      result(Utility.origin())
    case "getKaHeader":
      result(Utility.kaHeader())
    case "launchBrowserTab":
        let args = call.arguments as! Dictionary<String, String>
        let url = args["url"]
        let redirectUri = args["redirect_uri"]
        launchBrowserTab(url: url!, redirectUri: redirectUri, result: result)
    case "authorizeWithTalk":
        let args = call.arguments as! Dictionary<String, String>
        let clientId = args["client_id"]
        let redirectUri = args["redirect_uri"]
        authorizeWithTalk(clientId: clientId!, redirectUri: redirectUri!, result: result)
    case "isKakaoTalkInstalled":
        guard let talkUrl = URL(string: "kakaokompassauth://authorize") else {
            result(false)
            return
        }
        result(UIApplication.shared.canOpenURL(talkUrl))
    case "launchKakaoTalk":
        let args = call.arguments as! Dictionary<String, String>
        let uri = args["uri"]
        launchKakaoTalk(uri: uri!, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

    private func launchKakaoTalk(uri: String, result: @escaping FlutterResult) {
        let urlObject = URL(string: uri)!
        if (UIApplication.shared.canOpenURL(urlObject)) {
            UIApplication.shared.open(urlObject, options: [:]) { (openResult) in
                result(openResult)
            }
        }
    }
    
    private func authorizeWithTalk(clientId: String, redirectUri: String, result: @escaping FlutterResult) {
        self.result = result
        self.redirectUri = redirectUri
        self.authorizeTalkCompletionHandler = {
            (callbackUrl:URL?, error: FlutterError?) in
            
            guard error == nil else {
                //TODO:error wrapping check
                result(error)
                return
            }
            
            guard let callbackUrl = callbackUrl else {
                //TODO:error type check
                result(FlutterError(code: "REDIRECT_URL_MISMATCH", message: "No callback url. This is probably a bug in Kakao Flutter SDK.", details: nil))
                return
            }
            result(callbackUrl.absoluteString)
            return
        }
        var parameters = [String:String]()
        parameters["client_id"] = clientId
        parameters["redirect_uri"] = redirectUri
        parameters["response_type"] = "code"

        guard let url = Utility.makeUrlWithParameters("kakaokompassauth://authorize", parameters: parameters) else {
            result(FlutterError(code: "makeURL", message: "This is probably a bug in Kakao Flutter SDK.", details: nil))
            return
        }

        UIApplication.shared.open(url, options: [:]) { (openResult) in
            if (!openResult) {
                result(FlutterError(code: "OPEN_URL_ERROR", message: "Failed to open KakaoTalk.", details: nil))
            }
        }
    }
    
    private func launchBrowserTab(url: String, redirectUri: String?, result: @escaping FlutterResult) {
        var keepMe: Any? = nil
        let completionHandler = { (url: URL?, err: Error?) in
            keepMe = nil

            if let err = err {
                if #available(iOS 12, *) {
                    if case ASWebAuthenticationSessionError.Code.canceledLogin = err {
                        result(FlutterError(code: "CANCELED", message: "User canceled login.", details: nil))
                        return
                    }
                } else {
                    if case SFAuthenticationError.Code.canceledLogin = err {
                        result(FlutterError(code: "CANCELED", message: "User canceled login.", details: nil))
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
            if #available(iOS 13.0, *) {
                session.presentationContextProvider = self
            }
            session.start()
            keepMe = session
        } else {
            let session = SFAuthenticationSession(url: urlObject, callbackURLScheme: redirectUriObject?.scheme, completionHandler: completionHandler)
            session.start()
            keepMe = session
        }
    }
    
    
    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let finalRedirectUri = self.redirectUri else {
            self.authorizeTalkCompletionHandler?(nil, FlutterError(code: "EUNKNOWN", message: "No redirect uri to compare. This is probably a bug in Kakao Flutter SDK.", details: nil))
            return true
        }
        if (url.absoluteString.hasPrefix(finalRedirectUri)) {
            self.authorizeTalkCompletionHandler?(url, nil)
            return true
        }
        self.authorizeTalkCompletionHandler?(nil, FlutterError(code: "REDIRECT_URL_MISMATCH", message: "Expected: \(finalRedirectUri), Actual: \(url.absoluteString)", details: nil))
        return true
    }
    
    @available(iOS 12.0, *)
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.keyWindow ?? ASPresentationAnchor()
    }
}
