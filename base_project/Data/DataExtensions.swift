//
//  DataExtensions.swift
//  base_project
//
//  Created by Pranav Singh on 07/07/24.
//

import Foundation

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

//MARK: - JSONKeyValuePair
typealias JSONKeyValuePair = [String: Any]

extension JSONKeyValuePair {
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
    
    func toJSONKeyValuePair() -> JSONKeyValuePair? {
        if let jsonObject = self.toJsonObject(),
           let parameter = jsonObject as? JSONKeyValuePair {
            return parameter
        }
        return nil
    }
}
