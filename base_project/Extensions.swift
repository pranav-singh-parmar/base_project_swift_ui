//
//  Extensions.swift
//  base_project
//
//  Created by Pranav Singh on 07/07/24.
//

import Foundation

//MARK: - Bundle
extension Bundle {
    var getBundleIdentifier: String? {
        return Bundle.main.bundleIdentifier
        //return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    }
    
    var appCurrentVersion: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var appName: String? {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
    }
}

//MARK: - Data
extension Data {
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
