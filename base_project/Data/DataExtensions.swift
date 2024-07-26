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
    
    func getErrorMessageFromJSONData(withAPIRequestError apiRequestError: APIRequestError) -> String? {
        let errorMessage: String?
        do {
            let jsonConvert = try JSONSerialization.jsonObject(with: self, options: [])
            let json = (jsonConvert as? JSONKeyValuePair) ?? [:]
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
            case .informationalError(_), .redirectionalError(_), .serverError(_), .unknown(_):
                errorMessage = json.getErrorMessage
            default:
                errorMessage = nil
            }
        } catch {
            errorMessage = nil
            print("Can't Fetch JSON Response:", error)
        }
        return errorMessage
    }
}

//MARK: - JSONKeyPair
let a: Dictionary<String, Any> = [:]
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
