//
//  Extensions.swift
//  base_project
//
//  Created by Pranav Singh on 01/08/22.
//

import Foundation
import SwiftUI
import Combine

//MARK: - UIApplication
extension UIApplication {
    
    var getKeyWindow: UIWindow? {
        if #available(iOS 15, *) {
            return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow
        } else {
            return UIApplication.shared.windows.first
        }
    }
    
    var getNavBarHeight: CGFloat {
        if let vc = getTopViewController() {
            return vc.navigationController?.navigationBar.bounds.height ?? 0
        }
        return 0
    }
    
    var getStatusBarHeight: CGFloat {
        if let window = getKeyWindow {
            return window.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        }
        return 0
    }
    
    func getTopViewController(_ baseVC: UIViewController? = UIApplication.shared.getKeyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = baseVC as? UINavigationController {
            return getTopViewController(navigationController.visibleViewController)
        }
        if let tabBarController = baseVC as? UITabBarController {
            return getTopViewController(tabBarController.selectedViewController)
        }
        if let presented = baseVC?.presentedViewController {
            return getTopViewController(presented)
        }
        return baseVC
    }
}

//MARK: - UIApplication handle tap gesture
extension UIApplication: UIGestureRecognizerDelegate {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func addTapGestureRecognizer() {
        guard let window = UIApplication.shared.getKeyWindow else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }
}

//MARK: - Data
extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
    
    func toStruct<T: Decodable>(_ decodingStruct: T.Type) -> T? {
        do {
            return try Singleton.sharedInstance.jsonDecoder.decode(decodingStruct.self, from: self)
        } catch let DecodingError.typeMismatch(type, context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("CodingPath:", context.codingPath)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("CodingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("CodingPath:", context.codingPath)
        } catch let DecodingError.dataCorrupted(context) {
            print("Data Corrupted:", context.debugDescription)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}

//MARK: - JSONKeyPair
typealias JSONKeyPair = [String: Any]

extension JSONKeyPair {
    func toStruct<T: Decodable>(_ decodingStruct: T.Type) -> T? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let model = jsonData.toStruct(decodingStruct)
            return model
        } catch {
            print("decoding error", error.localizedDescription)
        }
        return nil
    }
}

//MARK: - Encodable
extension Encodable {
    func toData() -> Data? {
        do {
            let jsonData = try Singleton.sharedInstance.jsonEncoder.encode(self)
            return jsonData
        } catch { print(error.localizedDescription) }
        return nil
    }
    
    func toJsonObject() -> Any? {
        if let jsonData = self.toData() {
            do {
                let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
                return json
            } catch { print(error.localizedDescription) }
        }
        return nil
    }
    
    func toJsonKeyPair() -> JSONKeyPair? {
        if let jsonObject = self.toJsonObject(),
           let parameter = jsonObject as? JSONKeyPair {
            return parameter
        }
        return nil
    }
}

//MARK: - UIColor
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    func toHexString() -> String {
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
}

//MARK: - Color
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Color {
    
    init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
    
    func toHexString() -> String {
        let components = self.cgColor?.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
}

//MARK: - View
extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition { transform(self) }
        else { self }
    }
}

//MARK: - Set<AnyCancellable>
typealias AnyCancellablesSet = Set<AnyCancellable>

extension AnyCancellablesSet {
    mutating func cancelAll() {
        forEach { $0.cancel() }
        removeAll()
    }
}
