import Flutter
import AuthenticationServices
import UIKit

public class KakaoFlutterSdkCommonPlugin: NSObject, FlutterPlugin, FlutterSceneLifeCycleDelegate, ASWebAuthenticationPresentationContextProviding {
    private var flutterApi: CommonFlutterApiProtocol?
    private static var instance: KakaoFlutterSdkCommonPlugin?
    private var pendingDeepLinkUrls: [String] = []
    private var isDeepLinkDeliveryInProgress = false
    private var isDeepLinkRetryScheduled = false
    private let pendingDeepLinkRetryInterval: TimeInterval = 0.3
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = KakaoFlutterSdkCommonPlugin()
        KakaoFlutterSdkCommonPlugin.instance = instance
        registrar.addApplicationDelegate(instance)
        registrar.addSceneDelegate(instance)

        CommonHostApiSetup.setUp(binaryMessenger: registrar.messenger(), api: CommonHostApiImpl(context: instance))
        instance.flutterApi = CommonFlutterApi(binaryMessenger: registrar.messenger())
    }

    // MARK: ASWebAuthenticationPresentationContextProviding
    
    
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.windows.filter { $0.isKeyWindow }.first ?? ASPresentationAnchor()
    }
    
    
    // MARK: FlutterSceneLifeCycleDelegate
    
        
    public func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions?) -> Bool {
        guard let urlContexts = connectionOptions?.urlContexts else { return false }
        return handleIncomingDeepLinks(urlContexts.map { $0.url })
    }

    public func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) -> Bool {
        return handleIncomingDeepLinks(URLContexts.map { $0.url })
    }
    
    
    // MARK: UIApplicationDelegate
    
    
    // deprecated https://docs.flutter.dev/release/breaking-changes/uiscenedelegate#migration-guide-for-flutter-plugins
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return handleIncomingDeepLinks([url])
    }

    private func handleIncomingDeepLinks(_ urls: [URL]) -> Bool {
        var handled = false

        for url in urls {
            guard url.scheme?.starts(with: "kakao") == true else { continue }
            guard url.host == "kakaolink" else { continue }

            enqueueDeepLink(url.absoluteString)
            handled = true
        }

        return handled
    }

    private func enqueueDeepLink(_ url: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.pendingDeepLinkUrls.append(url)
            self.flushPendingDeepLinks()
        }
    }

    private func flushPendingDeepLinks() {
        guard !isDeepLinkDeliveryInProgress else { return }
        guard !pendingDeepLinkUrls.isEmpty else { return }
        guard let flutterApi = flutterApi else {
            schedulePendingDeepLinkRetry()
            return
        }

        isDeepLinkDeliveryInProgress = true
        let deepLinkUrl = pendingDeepLinkUrls[0]
        flutterApi.onDeepLinkReceived(url: deepLinkUrl) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isDeepLinkDeliveryInProgress = false

                switch result {
                case .success:
                    self.isDeepLinkRetryScheduled = false
                    self.pendingDeepLinkUrls.removeFirst()
                    self.flushPendingDeepLinks()
                case .failure:
                    self.schedulePendingDeepLinkRetry()
                }
            }
        }
    }

    private func schedulePendingDeepLinkRetry() {
        guard !isDeepLinkRetryScheduled else { return }

        isDeepLinkRetryScheduled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + pendingDeepLinkRetryInterval) { [weak self] in
            guard let self = self else { return }
            self.isDeepLinkRetryScheduled = false
            self.flushPendingDeepLinks()
        }
    }
}
