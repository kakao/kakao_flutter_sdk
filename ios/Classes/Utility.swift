//
//  Utility.swift
//  kakao_flutter_sdk
//
//  Created by Hara Kang on 10/08/2019.
//

import Foundation

class Utility {
    static func kaHeader() -> String {
        return "os/\(os()) lang/\(lang()) res/\(res()) device/\(device()) origin/\(origin()) app_ver/\(appVer())"
    }
    
    private static func os() -> String {
        return "ios-\(UIDevice.current.systemVersion)"
    }
    
    private static func lang() -> String {
        return Locale.preferredLanguages.count > 0 ? Locale.preferredLanguages[0] : Locale.current.languageCode!
    }
    
    private static func res() -> String {
        return "\(UIScreen.main.bounds.size.width)x\(UIScreen.main.bounds.size.height)"
    }
    
    private static func device() -> String {
        return UIDevice.current.model
    }
    
    static func origin() -> String {
        return Bundle.main.bundleIdentifier!
    }
    
    private static func appVer() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }

    static func makeUrlStringWithParameters(_ url:String, parameters:[String:String]) -> String? {
        guard var components = URLComponents(string:url) else { return nil }
        components.queryItems = parameters.map { URLQueryItem(name: $0.0, value: $0.1)}
        return components.url?.absoluteString
    }
    
    static func makeUrlWithParameters(_ url:String, parameters:[String:String]) -> URL? {
        guard let finalStringUrl = makeUrlStringWithParameters(url, parameters:parameters) else { return nil }
        return URL(string:finalStringUrl)
    }
}
