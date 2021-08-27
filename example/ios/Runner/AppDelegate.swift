import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "kakao.flutter.sdk.sample", binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            guard call.method == "changePhase" else {
                result(FlutterMethodNotImplemented)
                return
            }
            self.changePhase()
            result(call.method)
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func getWindow() -> UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    private func changePhase() {
        showAlert()
    }
    
    @IBAction private func showAlert() {
        let controller = window?.rootViewController as! FlutterViewController
        let alert = UIAlertController(title: "The app must be restarted", message: "The app will shut down.\nPlease run the app again.", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "OK", style: .default) { (action) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    exit(0)
                }
            }
        }
        let close = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(close)
        alert.addAction(confirm)
        controller.present(alert, animated: true, completion: nil)
    }
}
