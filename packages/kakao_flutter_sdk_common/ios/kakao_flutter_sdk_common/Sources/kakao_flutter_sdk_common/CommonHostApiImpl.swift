import Foundation
import AuthenticationServices

#if os(iOS)
import Flutter
#endif

class CommonHostApiImpl: CommonHostApi {
    private var context: ASWebAuthenticationPresentationContextProviding

    init(context: ASWebAuthenticationPresentationContextProviding) {
        self.context = context
    }
    
    
    // MARK: - Public Method
    
    
    func isAppInstalled(appIdentifier: String) throws -> Bool {
        guard let url = URL(string: appIdentifier) else {
            throw PigeonError(code: "INVALID_SCHEME", message: "Invalid app scheme: \(appIdentifier)", details: nil)
        }
        return UIApplication.shared.canOpenURL(url)
    }
    
    func isKakaoTalkAvailable(appScheme: String?) throws -> Bool {
        let scheme = appScheme ?? "kakaokompassauth://authorize"
        return try isAppInstalled(appIdentifier: scheme)
    }
    
    func launchUrl(url: String, useBrowserSession: Bool, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let schemeUrl = URL(string: url) else {
            return completion(.failure(PigeonError(code: "INVALID_URL", message: "Invalid url: \(url)", details: nil)))
        }
        
        do {
            let installed = try isAppInstalled(appIdentifier: url)
            if !installed {
                return completion(.failure(PigeonError(code: "APP_NOT_INSTALLED", message: "App is not installed for url: \(url)", details: nil)))
            }
        } catch {
            return completion(.failure(error))
        }
        
        if ["http", "https"].contains(schemeUrl.scheme) {
            launchDefaultBrowser(url: schemeUrl, useBrowserSession: useBrowserSession, completion: completion)
        } else {
            launchBrowserApp(url: schemeUrl, completion: completion)
        }
    }
    
    func getPlatformData() throws -> PlatformData {
        return PlatformData(
            platformId: try getPlatformId(),
            origin: getOrigin(),
            kaHeader: getKaHeader(),
            appVer: getAppVersion()
        )
    }
    
    
    // MARK: - Private Method
    
    
    private func getPlatformId() throws -> FlutterStandardTypedData {
        guard let vendorId = UIDevice.current.identifierForVendor?.uuidString else {
            throw PigeonError(code: "UNAVAILABLE_ID", message: "Vendor ID is unavailable", details: nil)
        }
        guard let data = "SDK-\(vendorId)".data(using: .utf8) else {
            throw PigeonError(code: "ENCODING_ERROR", message: "Failed to encode vendor ID", details: nil)
        }
        return FlutterStandardTypedData(bytes: data)
    }
    
    private func getOrigin() -> String {
        return Bundle.main.bundleIdentifier ?? "unknown"
    }
    
    private func getKaHeader() -> String {
        return "os/\(getOs()) lang/\(getLang()) origin/\(getOrigin()) device/\(getDevice()) res/\(res())"
    }
    
    private func getAppVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    }
    
    private func getOs() -> String {
        return "ios-\(UIDevice.current.systemVersion)"
    }
    
    private func getLang() -> String {
        if let preferred = Locale.preferredLanguages.first {
            return preferred
        }
        
        let lang = Locale.current.languageCode ?? ""
        let region = Locale.current.regionCode ?? ""
        return "\(lang)-\(region)"
    }
    
    private func getDevice() -> String {
        return UIDevice.current.model
    }

    private func res() -> String {
        return "\(UIScreen.main.bounds.size.width)x\(UIScreen.main.bounds.size.height)"
    }
    
    private func launchBrowserApp(url: URL, completion: @escaping (Result<Void, any Error>) -> Void) {
        UIApplication.shared.open(url, options: [:]) { success in
            if success {
                completion(.success(()))
            } else {
                let error = PigeonError(code: "LAUNCH_FAILED", message: "Failed to launch url: \(url)", details: nil)
                completion(.failure(error))
            }
        }
    }
    
    private func launchDefaultBrowser(url: URL, useBrowserSession: Bool, completion: @escaping (Result<Void, any Error>) -> Void) {
        let session = ASWebAuthenticationSession(url: url, callbackURLScheme: nil, completionHandler: { (callbackURL: URL?, error: Error?) in
            guard error != nil else {
                completion(.success(Void()))
                return
            }
            
            if let sessionError = error as? ASWebAuthenticationSessionError {
                let canceledError = PigeonError(code: "CANCELED", message: "User canceled.", details: sessionError.localizedDescription)
                completion(.failure(canceledError))
                return
            }
            
            // do not reach here
            let unknownError = PigeonError(code: "Unknown", message: error?.localizedDescription, details: nil)
            completion(.failure(unknownError))
            return
        })
        
        session.presentationContextProvider = context
        session.prefersEphemeralWebBrowserSession = !useBrowserSession
        session.start()
    }
        
}
