//
//  DataExtensions.swift
//  base_project
//
//  Created by Pranav Singh on 07/07/24.
//

import Foundation

//MARK: - Data
extension Data {
    var toJSONKeyValuePair: JSONKeyValuePair? {
        do {
            let jsonConvert = try JSONSerialization.jsonObject(with: self, options: [])
            if let json = jsonConvert as? JSONKeyValuePair {
                return json
            }
        } catch {
            print("Can't Get JSON Response:", error)
        }
        return nil
    }
    
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
    
    func getErrorMessageFromJSONData(withAPIRequestError apiRequestError: APIRequestError) -> String? {
        let errorMessage: String?
        if let json = self.toJSONKeyValuePair {
            switch apiRequestError {
                //            case .internetNotConnected:
                //                errorMessage = "Check your Internet Connection"
                //            case .invalidHTTPURLResponse:
                //                errorMessage = "Invalid Response"
                //            case .timedOut:
                //                errorMessage = "Server Request timed out"
                //            case .networkConnectionLost:
                //                errorMessage = "Connection with Server lost"
                //            case .urlError(_):
                //                errorMessage = "URL not initialised"
                //            case .invalidMimeType:
                //                errorMessage = "Invalid response from Server"
            case .clientError(let clientErrorEnum):
                switch clientErrorEnum {
                case .unauthorised:
                    errorMessage = AppTexts.AlertMessages.yourSessionHasExpiredPleaseLoginAgain
                case .badRequest, .paymentRequired, .forbidden, .notFound, .methodNotAllowed, .notAcceptable, .uriTooLong, .other:
                    errorMessage = json.getErrorMessage
                }
            case .informationalError(_), .redirectionError(_), .serverError(_), .unknown(_):
                errorMessage = json.getErrorMessage
            default:
                errorMessage = nil
            }
        } else {
            errorMessage = nil
        }
        return errorMessage
    }
}

//MARK: - JSONKeyPair
let a: Dictionary<String, Any> = [:]
typealias JSONKeyValuePair = [String: Any]

extension JSONKeyValuePair {
    func toJSONStringFormat() -> String? {
        do {
            // Serialize to JSON
            let jsonData = try JSONSerialization.data(withJSONObject: self,
                                                      options: [.prettyPrinted, .withoutEscapingSlashes])
            
            // Convert to a string and print
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                return jsonString
            }
            print("Could not convert to string")
        } catch {
            print("Could not print parameters, Error -> \(error)")
        }
        return nil
    }
    
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
    
    var getErrorMessage: String {
        if let message = self["message"] as? String {
            return message
        } else if let error = self["error"] as? String {
            return error
        } else if let errorMessages = self["error"] as? [String] {
            var error = ""
            for message in errorMessages {
                if error != "" {
                    error = error + ", "
                }
                error = error + message
            }
            return error
        }
        return "Server Error"
    }
}

extension Array where Element == JSONKeyValuePair {
    func toJSONStringFormat() -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted, .withoutEscapingSlashes])
            // Convert to a string and print
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                return jsonString
            }
            print("Could not convert to string")
        } catch {
            print("Could not print parameters, Error -> \(error)")
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
