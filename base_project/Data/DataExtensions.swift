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
    
    func getErrorMessageFromJSONData(withAPIRequestError apiRequestError: APIRequestError) -> String {
//        do {
//            let jsonConvert = try JSONSerialization.jsonObject(with: self, options: [])
//            let json = (jsonConvert as? [String: AnyObject]) ?? [:]
//            switch apiRequestError {
//            case .clientError(let statusCode):
//                let clientErrorEnum = ClientErrorsEnum.getCorrespondingValue(forStatusCode: statusCode)
//                switch clientErrorEnum {
//                    case .unauthorized:
//                        Singleton.sharedInstance.alerts.handle401StatueCode()
//                    case .badRequest, .paymentRequired, .forbidden, .notFound, .methodNotAllowed, .notAcceptable, .uriTooLong, .other:
//                        if let message = json["message"] as? String {
//                            Singleton.sharedInstance.alerts.errorAlertWith(message: message)
//                        } else if let errorMessage = json["error"] as? String {
//                            Singleton.sharedInstance.alerts.errorAlertWith(message: errorMessage)
//                        } else if let errorMessages = json["error"] as? [String] {
//                            var errorMessage = ""
//                            for message in errorMessages {
//                                if errorMessage != "" {
//                                    errorMessage = errorMessage + ", "
//                                }
//                                errorMessage = errorMessage + message
//                            }
//                            Singleton.sharedInstance.alerts.errorAlertWith(message: errorMessage)
//                        } else{
//                            Singleton.sharedInstance.alerts.errorAlertWith(message: "Server Error")
//                        }
//                }
//            case .internetNotConnected:
//                "Check your Internet Connection"
//            case .invalidHTTPURLResponse:
//                "Invalid Response"
//            case .timedOut:
//                "Server Request timed out"
//            case .networkConnectionLost:
//                "Connection with Server lost"
//            case .urlError(_):
//                "URL not initialised"
//            case .invalidMimeType:
//                "Invalid response from Server"
//            case .informationalError(_), .redirectionalError(_), .serverError(_), .unknown(_):
//                json["message"] as? String
//            case .redirectionalError(_):
//                json["message"] as? String
//            case .serverError(_):
//                json["message"] as? String
//            case .unknown(_):
//                json["message"] as? String
//            }
//            //                switch clientErrorEnum {
//            //                case .unauthorized:
//            //                    Singleton.sharedInstance.alerts.handle401StatueCode()
//            //                case .badRequest, .paymentRequired, .forbidden, .notFound, .methodNotAllowed, .notAcceptable, .uriTooLong, .other:
//            //                    if let message = json["message"] as? String {
//            //                        Singleton.sharedInstance.alerts.errorAlertWith(message: message)
//            //                    } else if let errorMessage = json["error"] as? String {
//            //                        Singleton.sharedInstance.alerts.errorAlertWith(message: errorMessage)
//            //                    } else if let errorMessages = json["error"] as? [String] {
//            //                        var errorMessage = ""
//            //                        for message in errorMessages {
//            //                            if errorMessage != "" {
//            //                                errorMessage = errorMessage + ", "
//            //                            }
//            //                            errorMessage = errorMessage + message
//            //                        }
//            //                        Singleton.sharedInstance.alerts.errorAlertWith(message: errorMessage)
//            //                    } else{
//            //                        Singleton.sharedInstance.alerts.errorAlertWith(message: "Server Error")
//            //                    }
//            //                }
//        } catch {
//            print("Can't Fetch JSON Response:", error)
//        }
        return ""
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
