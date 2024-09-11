//
//  AppConstants.swift
//  base_project
//
//  Created by Pranav Singh on 01/08/22.
//

import Foundation
import SwiftUI

//MARK: - Enums
enum BitterFontEnum {
    case light, regular, medium, semiBold, bold
}

//MARK: - AppInfo
struct AppInfo {
    static let bundleIdentifier = Bundle.main.bundleIdentifier
    // static let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    static let appCurrentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
    static var appId = 0
}

//MARK: - AppURLs
class AppURLs {
    private static let baseURL = "https://www.breakingbadapi.com/"
    
    static func getAPIURL() -> String {
        return baseURL + "api/"
    }
    
    //    func updateAPIURL(_ urlString: String) {
    //        apiURL = urlString
    //    }
}


//MARK: - App Colors
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Color {
    static let blackColor = Color(.blackColor)
    static let blackColorForAllModes = Color(.blackColorForAllModes)
    
    static let darkGrayColor = Color(.darkGrayColor)
    static let defaultLightGray = Color(.defaultLightGray)
    static let lightGrayColor = Color(.lightGrayColor)
    static let placeholderColor = Color(.placeholderColor)
    
    static let whiteColor = Color(.whiteColor)
    static let whiteColorForAllModes = Color(.whiteColorForAllModes)
}

//MARK: - UIColor
extension UIColor {
    static let blackColor = UIColor(named: "blackColor") ?? UIColor.clear
    static let blackColorForAllModes = UIColor(named: "blackColorForAllModes") ?? UIColor.clear
    
    static let darkGrayColor = UIColor(named: "darkGrayColor") ?? UIColor.clear
    static let defaultLightGray = UIColor(named: "defaultLightGray") ?? UIColor.clear
    static let lightGrayColor = UIColor(named: "lightGrayColor") ?? UIColor.clear
    static let placeholderColor = UIColor(named: "placeholderColor") ?? UIColor.clear
    
    static let whiteColor = UIColor(named: "whiteColor") ?? UIColor.clear
    static let whiteColorForAllModes = UIColor(named: "whiteColorForAllModes") ?? UIColor.clear
}

//MARK: Font
extension Font {
    static func bitterLight(ofSize size: CGFloat) -> Font {
        return Font(UIFont.bitterLight(ofSize: size) as CTFont)
    }
    
    static func bitterRegular(ofSize size: CGFloat) -> Font {
        return Font(UIFont.bitterRegular(ofSize: size) as CTFont)
    }
    
    static func bitterMedium(ofSize size: CGFloat) -> Font {
        return Font(UIFont.bitterMedium(ofSize: size) as CTFont)
    }
    
    static func bitterSemiBold(ofSize size: CGFloat) -> Font {
        return Font(UIFont.bitterSemiBold(ofSize: size) as CTFont)
    }
    
    static func bitterBold(ofSize size: CGFloat) -> Font {
        return Font(UIFont.bitterBold(ofSize: size) as CTFont)
    }
    
    static func bitterFont(_ font: BitterFontEnum, ofSize size: CGFloat) -> Font {
        switch font {
        case .light:
            return bitterLight(ofSize: size)
        case .regular:
            return bitterRegular(ofSize: size)
        case .medium:
            return bitterMedium(ofSize: size)
        case .semiBold:
            return bitterSemiBold(ofSize: size)
        case .bold:
            return bitterBold(ofSize: size)
        }
    }
    
    public static let bitterLargeTitle: Font = Font(UIFont.bitterLargeTitle as CTFont)
    public static let bitterTitle: Font = Font(UIFont.bitterTitle as CTFont)
    public static let bitterTitle2: Font = Font(UIFont.bitterTitle2 as CTFont)
    public static let bitterTitle3: Font = Font(UIFont.bitterTitle3 as CTFont)
    public static let bitterHeadline: Font = Font(UIFont.bitterHeadline as CTFont)
    public static let bitterSubheadline: Font = Font(UIFont.bitterSubheadline as CTFont)
    public static let bitterBody: Font = Font(UIFont.bitterBody as CTFont)
    public static let bitterCallout: Font = Font(UIFont.bitterCallout as CTFont)
    public static let bitterFootnote: Font = Font(UIFont.bitterFootnote as CTFont)
    public static let bitterCaption: Font = Font(UIFont.bitterCaption as CTFont)
    public static let bitterCaption2: Font = Font(UIFont.bitterCaption2 as CTFont)
}

//MARK: - UIFont
extension UIFont {
    
    static func bitterLight(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Bitter-Light", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func bitterRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Bitter-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func bitterMedium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Bitter-Medium", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func bitterSemiBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Bitter-SemiBold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func bitterBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Bitter-Bold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func bitterFont(_ font: BitterFontEnum, ofSize size: CGFloat) -> UIFont {
        switch font {
        case .light:
            return bitterLight(ofSize: size)
        case .regular:
            return bitterRegular(ofSize: size)
        case .medium:
            return bitterMedium(ofSize: size)
        case .semiBold:
            return bitterSemiBold(ofSize: size)
        case .bold:
            return bitterBold(ofSize: size)
        }
    }
    
    public static let bitterLargeTitle: UIFont = .bitterFont(.medium, ofSize: 35)
    public static let bitterTitle: UIFont = .bitterFont(.medium, ofSize: 28)
    public static let bitterTitle2: UIFont = .bitterFont(.medium, ofSize: 22)
    public static let bitterTitle3: UIFont = .bitterFont(.medium, ofSize: 20)
    public static let bitterHeadline: UIFont = .bitterFont(.semiBold, ofSize: 17)
    public static let bitterSubheadline: UIFont = .bitterFont(.regular, ofSize: 15)
    public static let bitterBody: UIFont = .bitterFont(.regular, ofSize: 17)
    public static let bitterCallout: UIFont = .bitterFont(.regular, ofSize: 15)
    public static let bitterFootnote: UIFont = .bitterFont(.regular, ofSize: 13)
    public static let bitterCaption: UIFont = .bitterFont(.regular, ofSize: 12)
    public static let bitterCaption2: UIFont = .bitterFont(.regular, ofSize: 11)
}
