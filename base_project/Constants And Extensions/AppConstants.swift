//
//  AppConstants.swift
//  base_project
//
//  Created by Pranav Singh on 01/08/22.
//

import Foundation
import SwiftUI

struct AppConstants {
    
    static let baseURL = "https://www.breakingbadapi.com/"
    static let dimensions = UIScreen.main.bounds.size
    
    //MARK: - AppInfo
    struct AppInfo {
        static let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
        static let appCurrentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        static let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
        static var appId = 0
    }
    
    //MARK: - DeviceDimensions
    struct DeviceDimensions {
        static let width = dimensions.width
        static let height = dimensions.height
    }
    
    //MARK: - AppURLs
    struct AppURLs {
        static let apiURL = baseURL + "api/"
    }
    
    //MARK: - ApiEndPoints
    struct ApiEndPoints {
        static let characters = AppURLs.apiURL + "characters"
    }
}

//MARK: - enums
enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

enum ParameterEncoding {
    case None, QueryParameters, JsonBody, URLFormEncoded, FormData
}

enum JsonStructEnum {
    case OnlyModel, OnlyJson, Both
}

enum ApiStatus {
    case NotHitOnce, IsBeingHit, ApiHit, ApiHitWithError
}

enum FontEnum {
    case Light, Regular, Medium, Bold
}

//MARK: - App Colors
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Color {
    static let blackColor = Color(.blackColor)
    static let blackColorForAllModes = Color(.blackColorForAllModes)
    static let whiteColor = Color(.whiteColor)
    static let whiteColorForAllModes = Color(.whiteColorForAllModes)
    
    static let grayColor = Color(.grayColor)
    static let defaultLightGray = Color(.defaultLightGray)
    static let lightGray = Color(.lightGray)
    static let placeHolderColor = Color(.placeHolderColor)
    static let shimmerColor = Color(.shimmerColor)
    static let darkGrayColor = Color(.darkGrayColor)
    
    static let primaryColor = Color(.primaryColor)
    static let greenColor = Color(.greenColor)
    static let redColor = Color(.redColor)
    static let orangeColor = Color(.orangeColor)
    static let lightBlue = Color(.lightBlue)
}

//MARK: - UIColor
extension UIColor {
    static let blackColor = UIColor(named: "blackColor") ?? UIColor.clear
    static let blackColorForAllModes = UIColor(named: "blackColorForAllModes") ?? UIColor.clear
    static let whiteColor = UIColor(named: "whiteColor") ?? UIColor.clear
    static let whiteColorForAllModes = UIColor(named: "whiteColorForAllModes") ?? UIColor.clear
    
    static let grayColor = UIColor(named: "grayColor") ?? UIColor.clear
    static let defaultLightGray = UIColor(named: "defaultLightGray") ?? UIColor.clear
    static let lightGray = UIColor(named: "lightGray") ?? UIColor.clear
    static let placeHolderColor = UIColor(named: "placeHolderColor") ?? UIColor.clear
    static let shimmerColor = UIColor(named: "shimmerColor") ?? UIColor.clear
    static let darkGrayColor = UIColor(named: "darkGrayColor") ?? UIColor.clear
    
    static let primaryColor = UIColor(named: "primaryColor") ?? UIColor.clear
    static let greenColor = UIColor(named: "greenColor") ?? UIColor.clear
    static let redColor = UIColor(named: "redColor") ?? UIColor.clear
    static let orangeColor = UIColor(named: "orangeColor") ?? UIColor.clear
    static let lightBlue = UIColor(named: "lightBlue") ?? UIColor.clear
}

//MARK: Font
extension Font {
    static func robotoLight(size: CGFloat) -> Font {
        return Font(UIFont.robotoLight(size: size) as CTFont)
    }
    
    static func robotoRegular(size: CGFloat) -> Font {
        return Font(UIFont.robotoRegular(size: size) as CTFont)
    }
    
    static func robotoMedium(size: CGFloat) -> Font {
        return Font(UIFont.robotoMedium(size: size) as CTFont)
    }
    
    static func robotoBold(size: CGFloat) -> Font {
        return Font(UIFont.robotoBold(size: size) as CTFont)
    }
}

//MARK: - UIFont
extension UIFont {
    static func robotoLight(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Light", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func robotoRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func robotoMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Medium", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func robotoBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Bold", size: size) ?? .systemFont(ofSize: size)
    }
}
