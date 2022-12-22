//
//  AppConstants.swift
//  base_project
//
//  Created by Pranav Singh on 01/08/22.
//

import Foundation
import SwiftUI

//MARK: - DeviceDimensions
struct DeviceDimensions {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
}

class AppURLs {
    static let baseURL = "https://www.breakingbadapi.com/"
    
    static func getAPIURL() -> String {
        return baseURL + "api/"
    }
    
    //    func updateAPIURL(_ urlString: String) {
    //        apiURL = urlString
    //    }
}

//MARK: - AppInfo
struct AppInfo {
    static let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    static let appCurrentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
    static var appId = 0
}

//MARK: - enums
enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

enum ParameterEncoding: String {
//    init?(rawValue: String) {
//        <#code#>
//    }
//    
//    var rawValue: String
//    
//    typealias RawValue = String
//    
//    case JSONBody = "", URLFormEncoded = "", FormData(String) = ""
    case JSONBody, URLFormEncoded, FormData
}

//https://developer.mozilla.org/en-US/docs/Web/HTTP/Status#server_error_responses
//Informational responses (100-199)
//Successful responses (200–299)
//Redirection messages (300–399)
//Client error responses (400–499)
//Server error responses (500–599)
enum APIError: Error {
    case InternetNotConnected, UrlNotValid, MapError, InvalidHTTPURLResponse, InformationalError(Int), DecodingError, RedirectionalError(Int), ClientError(ClientErrorsEnum), ServerError(Int), Unknown(Int)
}

enum ClientErrorsEnum: Int {
    case BadRequest = 400, Unauthorized = 401, PaymentRequired = 402, Forbidden = 403, NotFound = 404, MethodNotAllowed = 405, NotAcceptable = 406, URITooLong = 414, Other
}

enum ApiStatus {
    case NotHitOnce, IsBeingHit, ApiHit, ApiHitWithError
}

enum FontEnum {
    case Light, Regular, Medium, SemiBold, Bold
}

//MARK: - App Colors
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Color {
    static let blackColor = Color(.blackColor)
    static let blackColorForAllModes = Color(.blackColorForAllModes)
    static let whiteColor = Color(.whiteColor)
    static let whiteColorForAllModes = Color(.whiteColorForAllModes)
    
    static let defaultLightGray = Color(.defaultLightGray)
    static let shimmerColor = Color(.shimmerColor)
}

//MARK: - UIColor
extension UIColor {
    static let blackColor = UIColor(named: "blackColor") ?? UIColor.clear
    static let blackColorForAllModes = UIColor(named: "blackColorForAllModes") ?? UIColor.clear
    static let whiteColor = UIColor(named: "whiteColor") ?? UIColor.clear
    static let whiteColorForAllModes = UIColor(named: "whiteColorForAllModes") ?? UIColor.clear
    
    static let defaultLightGray = UIColor(named: "defaultLightGray") ?? UIColor.clear
    static let shimmerColor = UIColor(named: "shimmerColor") ?? UIColor.clear
}

//MARK: Font
extension Font {
    static func bitterLight(size: CGFloat) -> Font {
        return Font(UIFont.bitterLight(size: size) as CTFont)
    }
    
    static func bitterRegular(size: CGFloat) -> Font {
        return Font(UIFont.bitterRegular(size: size) as CTFont)
    }
    
    static func bitterMedium(size: CGFloat) -> Font {
        return Font(UIFont.bitterMedium(size: size) as CTFont)
    }
    
    static func bitterSemiBold(size: CGFloat) -> Font {
        return Font(UIFont.bitterSemiBold(size: size) as CTFont)
    }
    
    static func bitterBold(size: CGFloat) -> Font {
        return Font(UIFont.bitterBold(size: size) as CTFont)
    }
}

//MARK: - UIFont
extension UIFont {
    static func bitterLight(size: CGFloat) -> UIFont {
        return UIFont(name: "Bitter-Light", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func bitterRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Bitter-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func bitterMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "Bitter-Medium", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func bitterSemiBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Bitter-SemiBold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func bitterBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Bitter-Bold", size: size) ?? .systemFont(ofSize: size)
    }
}
