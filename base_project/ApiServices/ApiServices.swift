//
//  ApiServices.swift
//  base_project
//
//  Created by Pranav Singh on 01/08/22.
//

import Foundation
import Network
import Combine

protocol ViewModel: ObservableObject {
    func clearAllCancellables()
}

class ApiServices {
    
    func getQueryItems(urlString: String, params: [String: Any]) -> URLComponents? {
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = []
        for (keyName, value) in params {
            urlComponents?.queryItems?.append(URLQueryItem(name: keyName, value: "\(value)"))
        }
        if let component = urlComponents {
            //https://stackoverflow.com/questions/27723912/swift-get-request-with-parameters
            //this code is added so that any space in the value can be handled
            urlComponents?.percentEncodedQuery = component.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        }
        return urlComponents
    }
    
    func getURLRequest(httpMethod: HTTPMethod, urlString: String, isAuthApi: Bool, parameterEncoding: ParameterEncoding, params: [String: Any]?, imageModel: [ImageModel]?) -> URLRequest? {
        
        var urlRequest: URLRequest?
        
        switch parameterEncoding {
        case .None:
            if let url = URL(string: urlString) {
                urlRequest = URLRequest(url: url)
            }
        case .QueryParameters:
            if let params = params {
                let urlComponents = getQueryItems(urlString: urlString, params: params)
                if let url = urlComponents?.url {
                    urlRequest = URLRequest(url: url)
                }
            } else if let url = URL(string: urlString) {
                urlRequest = URLRequest(url: url)
            }
        case .JsonBody:
            if let url = URL(string: urlString) {
                urlRequest = URLRequest(url: url)
                if let params = params {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                        urlRequest?.httpBody = jsonData
                        urlRequest?.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    } catch {
                        print("error in \(urlString)", error.localizedDescription)
                    }
                }
            }
        case .URLFormEncoded:
            if let url = URL(string: urlString) {
                urlRequest = URLRequest(url: url)
                if let params = params {
                    let urlComponents = getQueryItems(urlString: urlString, params: params)
                    let formEncodedString = urlComponents?.percentEncodedQuery
                    if let formEncodedData = formEncodedString?.data(using: .utf8) {
                        urlRequest?.httpBody = formEncodedData
                        urlRequest?.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                    } else {
                        print("error in \(urlString) not able to process URLFormEncoded")
                    }
                }
            }
        case .FormData:
            //https://stackoverflow.com/questions/26162616/upload-image-with-parameters-in-swift
            //https://orjpap.github.io/swift/http/ios/urlsession/2021/04/26/Multipart-Form-Requests.html
            //https://bhuvaneswarikittappa.medium.com/upload-image-to-server-using-multipart-form-data-in-ios-swift-5c4eb6de26e2
            if let url = URL(string: urlString) {
                urlRequest = URLRequest(url: url)
                
                let boundary = "Boundary-\(UUID().uuidString)"
                let lineBreak = "\r\n"
                
                var body = Data()
                
                if let params = params {
                    for (key, value) in params {
                        if let params = value as? [String: Any], let data = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) {
                            body.appendString("--\(boundary + lineBreak)")
                            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                            //body.appendString("Content-Type: application/json;charset=utf-8\(lineBreak + lineBreak)")
                            body.append(data)
                            body.appendString(lineBreak)
                        } else if let data = "\(value)".data(using: .utf8) {
                            body.appendString("--\(boundary + lineBreak)")
                            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                            //body.appendString("Content-Type: text/plain;charset=utf-8\(lineBreak + lineBreak)")
                            body.append(data)
                            body.appendString(lineBreak)
                        }
                    }
                }
                
                if let imageModel = imageModel {
                    for image in imageModel {
                        body.appendString("--\(boundary + lineBreak)")
                        body.appendString("Content-Disposition: form-data; name=\"\(image.fileKeyName)\"; filename=\"\(image.fileName)\"\(lineBreak)")
                        body.appendString("Content-Type: \(image.mimeType + lineBreak + lineBreak)")
                        body.append(image.file)
                        body.appendString(lineBreak)
                    }
                }
                
                body.appendString("--\(boundary)--\(lineBreak)")
                
                urlRequest?.httpBody = body
                urlRequest?.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                urlRequest?.addValue("\(body.count)", forHTTPHeaderField: "Content-Length")
            }
        }
        
        urlRequest?.httpMethod = httpMethod.rawValue
        
        //set headers
        urlRequest?.addValue("iOS", forHTTPHeaderField: "device")
        urlRequest?.addValue("application/json", forHTTPHeaderField: "Accept")
        //urlRequest?.addValue("token", forHTTPHeaderField: "Authorization")
        
        print("url", urlRequest?.url?.absoluteString ?? "url not set")
        print("http method is", urlRequest?.httpMethod ?? "http method not assigned")
        print("headers are", urlRequest?.allHTTPHeaderFields ?? [:])
        print("paramenterEncoding is", parameterEncoding)
        print("http body data", urlRequest?.httpBody ?? Data())
        print("params are", params ?? [:])
        
        return urlRequest
    }
    
    func hitApi<T: Decodable>(httpMethod: HTTPMethod, urlString: String, isAuthApi: Bool = false, parameterEncoding: ParameterEncoding = .None, params : [String: Any]? = nil, imageModel: [ImageModel]? = nil, returnRequired: JsonStructEnum = JsonStructEnum.OnlyModel, decodingStruct: T.Type, outputBlockForInternetNotConnected: @escaping () -> Void) -> AnyPublisher<T, APIError> {
        
        if Singleton.sharedInstance.appEnvironmentObject.isConnectedToInternet {
            
            if let urlRequest = getURLRequest(httpMethod: httpMethod, urlString: urlString, isAuthApi: isAuthApi, parameterEncoding: parameterEncoding, params: params, imageModel: imageModel) {
                return URLSession
                    .shared
                    .dataTaskPublisher(for: urlRequest)
                    .receive(on: DispatchQueue.main)
                    .mapError{_ in APIError.MapError}
                    //.decode(type: T.self, decoder: Singleton.sharedInstance.jsonDecoder)
                    .flatMap { data, response -> AnyPublisher<T, APIError> in
                        guard let response = response as? HTTPURLResponse else{
                            return Fail(error: APIError.InvalidHTTPURLResponse).eraseToAnyPublisher()
                        }
                        let jsonConvert = try? JSONSerialization.jsonObject(with: data, options: [])
                        let json = jsonConvert as AnyObject
                        
                        switch response.statusCode {
                        case 100...199:
                            return Fail(error: APIError.InformationalError(response.statusCode)).eraseToAnyPublisher()
                        case 200...299:
                            //let model = try JSONDecoder().decode(decodingStruct.self, from: data)
                            return Just(data).decode(type: decodingStruct.self, decoder: Singleton.sharedInstance.jsonDecoder)
                                .mapError{_ in APIError.DecodingError}
                                .eraseToAnyPublisher()
                        case 300...399:
                            return Fail(error: APIError.RedirectionalError(response.statusCode)).eraseToAnyPublisher()
                        case 400...499:
                            let clientErrorEnum = ClientErrorsEnum(rawValue: response.statusCode) ?? .Other
                            switch clientErrorEnum {
                            case .Unauthorized:
                                Singleton.sharedInstance.alerts.handle401StatueCode()
                            case .BadRequest, .PaymentRequired, .Forbidden, .Required, .NotFound, .MethodNotAllowed, .URITooLong, .Other:
                                if let message = json["message"] as? String {
                                    Singleton.sharedInstance.alerts.errorAlert(message: message)
                                } else if let errorMessage = json["error"] as? String {
                                    Singleton.sharedInstance.alerts.errorAlert(message: errorMessage)
                                } else if let errorMessages = json["error"] as? [String] {
                                    var errorMessage = ""
                                    for message in errorMessages {
                                        if errorMessage != "" {
                                            errorMessage = errorMessage + ", "
                                        }
                                        errorMessage = errorMessage + message
                                    }
                                    Singleton.sharedInstance.alerts.errorAlert(message: errorMessage)
                                } else{
                                    Singleton.sharedInstance.alerts.errorAlert(message: "Server Error")
                                }
                            }
                            return Fail(error: APIError.ClientError(clientErrorEnum)).eraseToAnyPublisher()
                        case 500...599:
                            return Fail(error: APIError.ServerError(response.statusCode)).eraseToAnyPublisher()
                        default:
                            return Fail(error: APIError.Unknown(response.statusCode)).eraseToAnyPublisher()
                        }
                    }.eraseToAnyPublisher()
            } else {
                return Fail(error: APIError.UrlNotValid).eraseToAnyPublisher()
            }
        } else {
            let monitor = NWPathMonitor()
            let queue = DispatchQueue(label: urlString)
            monitor.pathUpdateHandler = { path in
                DispatchQueue.main.async {
                    if path.status == .satisfied {
                        outputBlockForInternetNotConnected()
                        monitor.cancel()
                    }
                }
            }
            monitor.start(queue: queue)
            return Fail(error: APIError.InternetNotConnected).eraseToAnyPublisher()
        }
    }
}

//MARK: - ImageModel
struct ImageModel: Codable{
    let file: Data
    let fileKeyName: String
    let fileName: String
    // mime type is file type(image, video etc.)
    let mimeType: String
}

enum APIError: Error {
    case InternetNotConnected
    case UrlNotValid
    case MapError
    case InvalidHTTPURLResponse
    case InformationalError(Int)
    case DecodingError
    case RedirectionalError(Int)
    case ClientError(ClientErrorsEnum)
    case ServerError(Int)
    case Unknown(Int)
}

enum ClientErrorsEnum: Int {
    case BadRequest = 400, Unauthorized = 401, PaymentRequired = 402, Forbidden = 403, Required = 404, NotFound = 405, MethodNotAllowed = 406, URITooLong = 414, Other
}

//https://developer.mozilla.org/en-US/docs/Web/HTTP/Status#server_error_responses
//Informational responses (100-199)
//Successful responses (200–299)
//Redirection messages (300–399)
//Client error responses (400–499)
//Server error responses (500–599)

