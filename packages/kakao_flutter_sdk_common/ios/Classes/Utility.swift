import Foundation

class Utility {
    static func kaHeader() -> String {
        return "os/\(os()) lang/\(lang()) res/\(res()) device/\(device()) origin/\(origin()) app_ver/\(appVer())"
    }
    
    static func origin() -> String {
        return Bundle.main.bundleIdentifier!
    }
    
    static func appVer() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    static func makeUrlStringWithParameters(_ url:String, parameters:[String:Any]?) -> String? {
        guard var components = URLComponents(string:url) else { return nil }
        components.queryItems = parameters?.urlQueryItems
        return components.url?.absoluteString
    }
    
    static func makeUrlWithParameters(_ url:String, parameters:[String:Any]?) -> URL? {
        guard let finalStringUrl = makeUrlStringWithParameters(url, parameters:parameters) else { return nil }
        return URL(string:finalStringUrl)
    }
    
    static func makeLoginUrlWithParameters(_ url: String, universalLink: String? = nil, parameters: [String:Any]?) -> URL? {
        var parametersWithLaunchMethod: [String:Any]
        if (universalLink != nil) {
            parametersWithLaunchMethod = ["deep_link_method" : LaunchMethod.UniversalLink.rawValue]
        } else {
            parametersWithLaunchMethod = ["deep_link_method" : LaunchMethod.CustomScheme.rawValue]
        }
        parametersWithLaunchMethod.merge(parameters ?? [:], uniquingKeysWith: {(current, _) in current })
        
        guard let finalStringUrl = makeUrlStringWithParameters(url, parameters:parametersWithLaunchMethod) else {
            return nil
        }
        guard let universalLink = universalLink else {
            return URL(string: finalStringUrl)
        }
        
        let customSchemeStringUrl = "\(finalStringUrl)"
        let escapedStringUrl = finalStringUrl.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let universalLinkStringUrl = "\(universalLink)\(escapedStringUrl ?? "")"
        
        return URL(string:universalLinkStringUrl)
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
}

extension Dictionary {
    public var urlQueryItems: [URLQueryItem]? {
        let queryItems = self.map { (key, value) in
            URLQueryItem(name: String(describing: key),
                         value: String(describing: value))
        }
        return queryItems
    }
}

extension Dictionary where Key == String, Value: Any {
    public func toJsonString() -> String? {
        if let data = try? JSONSerialization.data(withJSONObject: self, options:[]) {
            return String(data:data, encoding: .utf8)
        }
        else {
            return nil
        }
    }
}
