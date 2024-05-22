import Flutter
import UIKit
import AuthenticationServices
import SafariServices
import CommonCrypto

public class SwiftKakaoFlutterSdkPlugin: NSObject, FlutterPlugin, FlutterStreamHandler, ASWebAuthenticationPresentationContextProviding {
    var result: FlutterResult? = nil
    var redirectUri: String? = nil
    var authorizeTalkCompletionHandler : ((URL?, FlutterError?) -> Void)?
    
    var eventSink: FlutterEventSink? = nil
    var initialLink: String? = nil
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: Constants.methodChannel, binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: Constants.eventChannel, binaryMessenger: registrar.messenger())
        let instance = SwiftKakaoFlutterSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        eventChannel.setStreamHandler(instance)
        registrar.addApplicationDelegate(instance) // This is necessary to receive open url delegate method.
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        func castArguments(_ arguments: Any?) -> Dictionary<String, String> {
            var args = arguments as! Dictionary<String, Any>
            let isPopup = (args["is_popup"] as? Bool) ?? true
            args["is_popup"] = (isPopup) ? "YES" : "NO"
            return args as! Dictionary<String, String>
        }
        
        switch call.method {
        case "appVer":
            result(Utility.appVer())
        case "packageName":
            result(Utility.origin())
        case "getOrigin":
            result(Utility.origin())
        case "getKaHeader":
            result(Utility.kaHeader())
        case "accountLogin":
            let args = castArguments(call.arguments)
            let url = args["url"]
            let redirectUri = args["redirect_uri"]
            launchBrowser(url: url!, redirectUri: redirectUri!, result: result)
        case "authorizeWithTalk":
            let args = castArguments(call.arguments)
            authorizeWithTalk(parameters: args, result: result)
        case "isKakaoTalkInstalled":
            let args = castArguments(call.arguments)
            let loginScheme = args["loginScheme"] ?? "kakaokompassauth://authorize"
            guard let talkUrl = URL(string: loginScheme) else {
                result(false)
                return
            }
            result(UIApplication.shared.canOpenURL(talkUrl))
        case "isKakaoNaviInstalled":
            let args = castArguments(call.arguments)
            let naviScheme = args["navi_origin"] ?? "kakaonavi-sdk://navigate"
            guard let naviUrl = URL(string: naviScheme) else {
                result(false)
                return
            }
            result(UIApplication.shared.canOpenURL(naviUrl))
        case "launchKakaoTalk":
            let args = castArguments(call.arguments)
            let uri = args["uri"]
            launchKakaoTalk(uri: uri!, result: result)
        case "launchBrowserTab", "selectShippingAddresses", "followChannel":
            let args = castArguments(call.arguments)
            let url = args["url"]
            launchBrowser(url: url!, redirectUri: nil, result: result)
        case "addChannel":
            let args = castArguments(call.arguments)
            let scheme = args["channel_scheme"] ?? "kakaoplus:plusfriend"
            let channelPublicId = args["channel_public_id"] ?? ""
            let urlObject = URL(string: "\(scheme)/home/\(channelPublicId)/add")!
            
            if (UIApplication.shared.canOpenURL(urlObject)) {
                UIApplication.shared.open(urlObject, options: [:])
            } else {
                result(FlutterError(code: "Error", message: "KakaoTalk is not installed. please install KakaoTalk", details: nil))
            }
            
        case "channelChat":
            let args = castArguments(call.arguments)
            let scheme = args["channel_scheme"] ?? "kakaoplus:plusfriend"
            let channelPublicId = args["channel_public_id"] ?? ""
            
            let urlObject = URL(string: "\(scheme)/talk/chat/\(channelPublicId)")!
            if (UIApplication.shared.canOpenURL(urlObject)) {
                UIApplication.shared.open(urlObject, options: [:])
            } else {
                result(FlutterError(code: "Error", message: "KakaoTalk is not installed. please install KakaoTalk", details: nil))
            }
            
        case "isKakaoTalkSharingAvailable":
            let args = castArguments(call.arguments)
            let talkSharingScheme = args["talkSharingScheme"] ?? "kakaolink://send"
            let isKakaoTalkSharingAvailable = UIApplication.shared.canOpenURL(URL(string:talkSharingScheme)!)
            result(isKakaoTalkSharingAvailable)
        case "navigate":
            let args = castArguments(call.arguments)
            let naviScheme = args["navi_scheme"] ?? "kakaonavi-sdk://navigate"
            let appKey = args["app_key"]
            let extras = args["extras"]
            let params = args["navi_params"]
            let url = Utility.makeUrlWithParameters(naviScheme, parameters: ["extras": extras!, "param": params!, "appkey": appKey!, "apiver": "1.0"])
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        case "shareDestination":
            let args = castArguments(call.arguments)
            let naviScheme = args["navi_scheme"] ?? "kakaonavi-sdk://navigate"
            let appKey = args["app_key"]
            let extras = args["extras"]
            let params = args["navi_params"]
            let url = Utility.makeUrlWithParameters(naviScheme, parameters: ["extras": extras!, "param": params!, "appkey": appKey!, "apiver": "1.0"])
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        case "platformId":
            guard let venderId = UIDevice.current.identifierForVendor?.uuidString else {
                result(FlutterError(code: "Error", message: "Can't get venderId", details: nil))
                return
            }
            let data = "SDK-\(venderId)".data(using: .utf8)
            result(data)
        case "receiveKakaoScheme":
            result(self.initialLink)
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
    
    private func authorizeWithTalk(parameters: [String:String], result: @escaping FlutterResult) {
        let loginScheme = parameters["loginScheme"] ?? "kakaokompassauth://authorize"
        let universalLink = parameters["universalLink"] ?? "https://talk-apps.kakao.com/scheme/"

        let sdkVersion = parameters["sdk_version"]!
        let clientId = parameters["client_id"]
        let redirectUri = parameters["redirect_uri"]
        let codeVerifier = parameters["code_verifier"]
        let prompt = parameters["prompt"]
        let state = parameters["state"]
        let nonce = parameters["nonce"]
        let settleId = parameters["settle_id"]

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
        var parameters = [String:Any]()
        parameters["client_id"] = clientId
        parameters["redirect_uri"] = redirectUri
        parameters["response_type"] = "code"
        parameters["headers"] = ["KA": "\(sdkVersion) \(Utility.kaHeader())"].toJsonString()

        if(codeVerifier != nil) {
            parameters["code_challenge"] = SdkCrypto.base64url(data: SdkCrypto.sha256(string: codeVerifier!)!)
            parameters["code_challenge_method"] = "S256"
        }

        if(prompt != nil) {
            parameters["prompt"] = prompt
        }

        if(state != nil) {
            parameters["state"] = state
        }

        if(nonce != nil) {
            parameters["nonce"] = nonce
        }
        if(settleId != nil) {
            parameters["settle_id"] = settleId
        }

        guard let url = Utility.makeLoginUrlWithParameters(loginScheme, universalLink: universalLink, parameters: parameters) else {
            result(FlutterError(code: "makeURL", message: "This is probably a bug in Kakao Flutter SDK.", details: nil))
            return
        }

        UIApplication.shared.open(url, options: [:]) { (openResult) in
            if !openResult {
                // If KakaoTalk fails to launch due to a universal link bug, retry with a custom scheme
                self.reauthorizeWithTalk(loginScheme: loginScheme, parameters: parameters)
            }
        }
    }
    
    private func launchBrowser(url: String, redirectUri: String?, result: @escaping FlutterResult) {
        var keepMe: Any? = nil
        let completionHandler = { (url: URL?, err: Error?) in
            keepMe = nil
            
            guard err != nil else {
                result(url?.absoluteString)
                return
            }
        
            if #available(iOS 12, *) {
                if let error = err as? ASWebAuthenticationSessionError {
                    result(FlutterError(code: "CANCELED", message: "User canceled login.", details: error.localizedDescription))
                    return
                }
            } else {
                if let error = err as? SFAuthenticationError {
                    result(FlutterError(code: "CANCELED", message: "User canceled login.", details: error.localizedDescription))
                    return
                }
            }
            result(FlutterError(code: "EUNKNOWN", message: err!.localizedDescription, details: nil))
            return
        }
        
        let urlObject = URL(string: url)!
        let redirectUriObject: URL? = redirectUri == nil ? nil : URL(string: redirectUri!)
        if #available(iOS 12, *) {
            let session = ASWebAuthenticationSession(url: urlObject, callbackURLScheme: redirectUriObject?.scheme, completionHandler: completionHandler)
            if #available(iOS 13.0, *) {
                session.presentationContextProvider = self
            }
            keepMe = session
            session.start()
        } else {
            let session = SFAuthenticationSession(url: urlObject, callbackURLScheme: redirectUriObject?.scheme, completionHandler: completionHandler)
            keepMe = session
            session.start()
        }
    }

    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let urlString = url.absoluteString
        
        guard urlString.starts(with: "kakao") else { return false }
            
        if redirectUri != nil && urlString.contains(Constants.oauthPath) {
            if urlString.hasPrefix(redirectUri!) {
                self.authorizeTalkCompletionHandler?(url, nil)
            } else {
                self.authorizeTalkCompletionHandler?(nil, FlutterError(code: "REDIRET_URL_MISMATCH", message: "Expected: \(redirectUri!), Actual: \(url.absoluteString)", details: nil))
            }
        } else if urlString.contains(Constants.talkSharingPath) {
            eventSink?(urlString)
        }
        // This results are treated as an OR, so it returns false so as not to affect the results of other plugin delegates.
        return false
    }

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        let url = (launchOptions[UIApplication.LaunchOptionsKey.url] as? URL)
        if (url != nil && url!.scheme != nil && url!.scheme!.starts(with: "kakao")
           && url!.host == Constants.talkSharingPath) {
            self.initialLink = url?.absoluteString
            eventSink?(url?.absoluteString)
        }
        return true
    }

    @available(iOS 12.0, *)
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.keyWindow ?? ASPresentationAnchor()
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }

    private func reauthorizeWithTalk(loginScheme: String, parameters: [String:Any]) {
        guard let url = Utility.makeLoginUrlWithParameters(loginScheme, universalLink: nil, parameters: parameters) else {
            self.result?(FlutterError(code: "makeURL", message: "This is probably a bug in Kakao Flutter SDK.", details: nil))
            return
        }

        UIApplication.shared.open(url, options: [:]) { openResult in
            if !openResult {
                self.result?(FlutterError(code: "OPEN_URL_ERROR", message: "Failed to open KakaoTalk.", details: nil))
            }
        }
    }
}

///:nodoc:
class SdkCrypto {
    public static func generateCodeVerifier() -> String? {
        let uuid = UUID().uuidString
        if let codeVerifierData = self.sha512(string: uuid) {
            return self.base64(data: codeVerifierData).replacingOccurrences(of: "=", with: "")
        }
        return nil
    }
    
    static func sha512(data: Data) -> Data? {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA512_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA512($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash)
    }
    
    static func sha512(string: String) -> Data? {
        guard let data = string.data(using: String.Encoding.utf8) else {
            return nil
        }
        return self.sha512(data: data)
    }
    
    public static func base64(data: Data) -> String {
        return data.base64EncodedString(options: [.endLineWithCarriageReturn, .endLineWithLineFeed])
    }
    
    public static func base64url(data: Data) -> String {
        let base64url = self.base64(data:data)
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        return base64url
    }
    
    public static func sha256(data: Data) -> Data? {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash)
    }
    
    public static func sha256(string: String) -> Data? {
        guard let data = string.data(using: String.Encoding.utf8) else {
            return nil
        }
        return self.sha256(data: data)
    }
}
