import Flutter
import UIKit
import AuthenticationServices

 public class KakaoFlutterSdkAuthPlugin: NSObject, FlutterPlugin, FlutterSceneLifeCycleDelegate, AuthHostApi, ASWebAuthenticationPresentationContextProviding {
    private var talkAuthorizeCompletion: ((Result<String, any Error>) -> Void)?
    
    
    // MARK: FlutterPlugin
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = KakaoFlutterSdkAuthPlugin()
        registrar.addApplicationDelegate(instance)
        registrar.addSceneDelegate(instance)
        
        AuthHostApiSetup.setUp(binaryMessenger: registrar.messenger(), api: instance)
    }
    
    
    // MARK: FlutterSceneLifeCycleDelegate
    
    
    public func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) -> Bool {
        guard let url = URLContexts.first?.url, url.scheme?.starts(with: "kakao") == true else { return false }
        
        if url.host == "oauth" {
            self.talkAuthorizeCompletion?(.success(url.absoluteString))
            return true
        }
        
        return false
    }
    
    
    // MARK: UIApplicationDelegate
    
    
    // deprecated https://docs.flutter.dev/release/breaking-changes/uiscenedelegate#migration-guide-for-flutter-plugins
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        guard url.scheme?.starts(with: "kakao") == true else { return false }
        
        if url.host == "oauth" {
            self.talkAuthorizeCompletion?(.success(url.absoluteString))
            return true
        }
        
        return false
    }
    
    
    // MARK: ASWebAuthenticationPresentationContextProviding
    
    
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.windows.filter { $0.isKeyWindow }.first ?? ASPresentationAnchor()
    }
    
    
    // MARK: AuthHostApi
    
    
    func authorizeWithKakaoTalk(
        appKey: String,
        redirectUri: String,
        kaHeader: String,
        pkce: PkceDto?,
        nonce: String?,
        channelPublicIds: [String]?,
        serviceTerms: [String]?,
        androidTalkPackageName: String, // Unused in iOS
        iosLoginScheme: String,
        iosUniversalLink: String,
        completion: @escaping (Result<String, any Error>) -> Void
    ) {
        self.talkAuthorizeCompletion = completion
        
        let loginUrl = createTalkLoginUrl(
            appKey: appKey,
            redirectUri: redirectUri,
            kaHeader: kaHeader,
            pkce: pkce,
            nonce: nonce,
            channelPublicIds: channelPublicIds,
            serviceTerms: serviceTerms,
            iosLoginScheme: iosLoginScheme,
            iosUniversalLink: iosUniversalLink
        )
        
        guard let loginUrl = loginUrl, let url = URL(string: loginUrl) else {
            completion(.failure(PigeonError(code: "INVALID_URL", message: "Failed to create login url", details: nil)))
            return
        }
        
        UIApplication.shared.open(url, options: [:]) { result in
            if (!result) {
                // If KakaoTalk fails to launch due to a universal link bug, retry with a custom scheme
                self.reauthorizeWithTalk(
                    appKey: appKey,
                    redirectUri: redirectUri,
                    kaHeader: kaHeader,
                    pkce: pkce,
                    nonce: nonce,
                    channelPublicIds: channelPublicIds,
                    serviceTerms: serviceTerms,
                    iosLoginScheme: iosLoginScheme,
                    completion: completion
                )
            }
        }
    }
    
    func authorize(url: String, redirectUri: String, completion: @escaping (Result<String, any Error>) -> Void) {
        guard let urlObj = URL(string: url), let redirectUriObj = URL(string: redirectUri) else {
            completion(.failure(PigeonError(code: "INVALID_URL", message: "Failed to create login url", details: nil)))
            return
        }
        
        let session = ASWebAuthenticationSession(url: urlObj, callbackURLScheme: redirectUriObj.scheme, completionHandler: { (callbackURL: URL?, error: Error?) in
            guard error != nil else {
                completion(.success(callbackURL!.absoluteString))
                return
            }
            
            if let sessionError = error as? ASWebAuthenticationSessionError {
                let canceledError = PigeonError(code: "CANCELED", message: "User canceled login.", details: sessionError.localizedDescription)
                completion(.failure(canceledError))
                return
            }
            
            // do not reach here
            let unknownError = PigeonError(code: "Unknown", message: error?.localizedDescription, details: nil)
            completion(.failure(unknownError))
            return
        })
        
        session.presentationContextProvider = self        
        session.start()
    }
    
    func launchAppsUrl(url: String, completion: @escaping (Result<String, any Error>) -> Void) {
        guard let appsUrl = URL(string: url) else {
            completion(.failure(PigeonError(code: "INVALID_URL", message: "Failed to create login url", details: nil)))
            return
        }
        
        let session = ASWebAuthenticationSession(url: appsUrl, callbackURLScheme: nil, completionHandler: { (callbackURL: URL?, error: Error?) in
            guard error != nil else {
                completion(.success(callbackURL!.absoluteString))
                return
            }
            
            if let sessionError = error as? ASWebAuthenticationSessionError {
                let canceledError = PigeonError(code: "CANCELED", message: "User canceled login.", details: sessionError.localizedDescription)
                completion(.failure(canceledError))
                return
            }
            
            // do not reach here
            let unknownError = PigeonError(code: "Unknown", message: error?.localizedDescription, details: nil)
            completion(.failure(unknownError))
            return
        })
        
        session.presentationContextProvider = self
        session.prefersEphemeralWebBrowserSession = true
        session.start()
    }
    
    private func reauthorizeWithTalk(
        appKey: String,
        redirectUri: String,
        kaHeader: String,
        pkce: PkceDto?,
        nonce: String?,
        channelPublicIds: [String]?,
        serviceTerms: [String]?,
        iosLoginScheme: String,
        completion: @escaping (Result<String, any Error>) -> Void
    ) {
        let customSchemeUrl = createTalkLoginUrl(
            appKey: appKey,
            redirectUri: redirectUri,
            kaHeader: kaHeader,
            pkce: pkce,
            nonce: nonce,
            channelPublicIds: channelPublicIds,
            serviceTerms: serviceTerms,
            iosLoginScheme: iosLoginScheme,
            iosUniversalLink: nil
        )
        
        guard let customSchemeUrl = customSchemeUrl, let url = URL(string: customSchemeUrl) else {
            completion(.failure(PigeonError(code: "INVALID_URL", message: "Failed to create login url", details: nil)))
            return
        }
        
        UIApplication.shared.open(url, options: [:]) { result in
            if (!result) {
                let error = PigeonError(code: "OPEN_URL_ERROR", message: "Failed to open KakaoTalk.", details: nil)
                completion(.failure(error))
            }
        }
    }
    
    private func createTalkLoginUrl(
        appKey: String,
        redirectUri: String,
        kaHeader: String,
        pkce: PkceDto?,
        nonce: String?,
        channelPublicIds: [String]?,
        serviceTerms: [String]?,
        iosLoginScheme: String,
        iosUniversalLink: String?
    )-> String? {
        let isUniversalLinkLogin = iosUniversalLink != nil && !iosUniversalLink!.isEmpty
        
        let loginSchemeUrl = createTalkSchemeLoginSchemeUrl(
            appKey: appKey,
            redirectUri: redirectUri,
            kaHeader: kaHeader,
            pkce: pkce,
            nonce: nonce,
            channelPublicIds:  channelPublicIds,
            serviceTerms: serviceTerms,
            iosLoginScheme: iosLoginScheme,
            launchMethod: isUniversalLinkLogin ? .UniversalLink : .CustomScheme
        )
        
        guard let universalLink = iosUniversalLink else {
            return loginSchemeUrl
        }
        
        let escapedStringUrl = loginSchemeUrl?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        return "\(universalLink)\(escapedStringUrl ?? "")"
    }
    
    private func createTalkSchemeLoginSchemeUrl(
        appKey: String,
        redirectUri: String,
        kaHeader: String,
        pkce: PkceDto?,
        nonce: String?,
        channelPublicIds: [String]?,
        serviceTerms: [String]?,
        iosLoginScheme: String,
        launchMethod: LaunchMethod
    ) -> String? {
        let queryParams: [String: String] = [
            Constants.clientId: appKey,
            Constants.redirectUri: redirectUri,
            Constants.responseType: Constants.code,
            Constants.kaHeader: kaHeader,
            Constants.codeChallenge: pkce?.codeChallenge,
            Constants.codeChallengeMethod: pkce?.codeChallengeMethod,
            Constants.nonce: nonce,
            Constants.channelPublicId: channelPublicIds?.joined(separator: ","),
            Constants.serviceTerms: serviceTerms?.joined(separator:","),
            Constants.deepLinkMethod: launchMethod.rawValue
        ].compactMapValues { $0 }
        
        var components = URLComponents(string: iosLoginScheme)
        components?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        return components?.url?.absoluteString
    }
}
