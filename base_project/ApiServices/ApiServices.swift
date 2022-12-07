//
//  ApiServices.swift
//  base_project
//
//  Created by Pranav Singh on 01/08/22.
//

import Foundation
import Network
import Combine

class ApiServices {
    
    func getQueryItems(forURLString urlString: String, andParamters parameters: JSONKeyPair) -> URLComponents? {
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = []
        for (keyName, value) in parameters {
            urlComponents?.queryItems?.append(URLQueryItem(name: keyName, value: "\(value)"))
        }
        if let component = urlComponents {
            //https://stackoverflow.com/questions/27723912/swift-get-request-with-parameters
            //this code is added because some servers interpret '+' as space becuase of x-www-form-urlencoded specification
            //so we have to percent escape it manually because URLComponents does not perform it
            //space is percent encoded as %20 and '+' is encoded as "%2B"
            urlComponents?.percentEncodedQuery = component.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        }
        return urlComponents
    }
    
    func getURL(ofHTTPMethod httpMethod: HTTPMethod,
                forAppEndpoint appEndpoint: AppEndpoints,
                withQueryParameters queryParameters: JSONKeyPair?) -> URLRequest? {
        return getURL(ofHTTPMethod: httpMethod, forString: appEndpoint.getURLString(), withQueryParameters: queryParameters)
    }
    
    private func getURL(ofHTTPMethod httpMethod: HTTPMethod,
                        forString urlString: String,
                        withQueryParameters queryParameters: JSONKeyPair?) -> URLRequest? {
        var urlRequest: URLRequest? = nil
        if let queryParameters {
            let urlComponents = getQueryItems(forURLString: urlString, andParamters: queryParameters)
            if let url = urlComponents?.url {
                urlRequest = URLRequest(url: url)
            }
        } else if let url = URL(string: urlString) {
            urlRequest = URLRequest(url: url)
        }
        urlRequest?.httpMethod = httpMethod.rawValue
        return urlRequest
    }
    
    func hitApi<T: Decodable>(withURLRequest urlRequest: URLRequest?,
                              decodingStruct: T.Type,
                              outputBlockForInternetNotConnected: @escaping () -> Void) -> AnyPublisher<T, APIError> {
        
        let urlString = urlRequest?.url?.absoluteString ?? "URL not set in \(#function)"
        
        print("url", urlString)
        print("http method is", urlRequest?.httpMethod ?? "http method not assigned")
        print("headers are", urlRequest?.allHTTPHeaderFields ?? [:])
        print("paramenterEncoding is", urlRequest?.value(forHTTPHeaderField: "Content-Type") ?? "None")
        print("http body data", urlRequest?.httpBody ?? Data())
//            print("parameters are", parameters ?? [:])
        
        if Singleton.sharedInstance.appEnvironmentObject.isConnectedToInternet {
            
            if let urlRequest {
                return URLSession
                    .shared
                    .dataTaskPublisher(for: urlRequest)
                    .receive(on: DispatchQueue.main)
                    .mapError { _ in
                        self.printApiError(.MapError, inUrl: urlString)
                        return APIError.MapError
                    }
                //.decode(type: T.self, decoder: Singleton.sharedInstance.jsonDecoder)
                    .flatMap { data, response -> AnyPublisher<T, APIError> in
                        guard let response = response as? HTTPURLResponse else{
                            return self.getApiErrorPublisher(.InvalidHTTPURLResponse, inUrl: urlString)
                        }
                        let jsonConvert = try? JSONSerialization.jsonObject(with: data, options: [])
                        let json = jsonConvert as AnyObject
                        
                        switch response.statusCode {
                        case 100...199:
                            return self.getApiErrorPublisher(.InformationalError(response.statusCode), inUrl: urlString)
                        case 200...299:
                            #if DEBUG
                            do {
                                let _ = try Singleton.sharedInstance.jsonDecoder.decode(decodingStruct.self, from: data)
                                print("")
                            } catch {
                                print(error.localizedDescription)
                            }
                            #endif
                            return Just(data).decode(type: decodingStruct.self, decoder: Singleton.sharedInstance.jsonDecoder)
                                .mapError { _ in
                                    self.printApiError(.DecodingError, inUrl: urlString)
                                    return APIError.DecodingError
                                }
                                .eraseToAnyPublisher()
                        case 300...399:
                            return self.getApiErrorPublisher(.RedirectionalError(response.statusCode), inUrl: urlString)
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
                            return self.getApiErrorPublisher(.ClientError(clientErrorEnum), inUrl: urlString)
                        case 500...599:
                            return self.getApiErrorPublisher(.ServerError(response.statusCode), inUrl: urlString)
                        default:
                            return Fail(error: APIError.Unknown(response.statusCode)).eraseToAnyPublisher()
                        }
                    }.eraseToAnyPublisher()
            } else {
                return getApiErrorPublisher(.UrlNotValid, inUrl: urlString)
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
            return getApiErrorPublisher(.InternetNotConnected, inUrl: urlString)
        }
    }
    
    private func getApiErrorPublisher<T: Decodable>(_ apiError: APIError, inUrl urlString: String) -> AnyPublisher<T, APIError> {
        printApiError(apiError, inUrl: urlString)
        return Fail(error: apiError).eraseToAnyPublisher()
    }
    
    private func printApiError(_ apiError: APIError, inUrl urlString: String) {
        print("in api \(urlString) \(apiError)")
    }
}

extension URLRequest {
    mutating func addHeaders(_ headers: JSONKeyPair? = nil, shouldAddAuthToken: Bool = false) {
        //set headers
        self.addValue("iOS", forHTTPHeaderField: "device")
        self.addValue("application/json", forHTTPHeaderField: "Accept")
        if shouldAddAuthToken {
            //urlRequest?.addValue("token", forHTTPHeaderField: "Authorization")
        }
        
        if let headers {
            headers.forEach { key, value in
                self.addValue(key, forHTTPHeaderField: "\(value)")
            }
        }
    }
    
    mutating func addParameters(_ parameters: JSONKeyPair?, withFileModel fileModel: [FileModel]? = nil, in parameterEncoding: ParameterEncoding) {
        let urlString = self.url?.absoluteString ?? ""
        switch parameterEncoding {
        case .JSONBody:
            if let parameters {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                    self.httpBody = jsonData
                    self.addValue("application/json", forHTTPHeaderField: "Content-Type")
                } catch {
                    print("error in \(urlString) with parameterEncoding \(parameterEncoding)", error.localizedDescription)
                }
            }
        case .URLFormEncoded:
            if let parameters {
                let urlComponents = Singleton.sharedInstance.apiServices.getQueryItems(forURLString: urlString, andParamters: parameters)
                let formEncodedString = urlComponents?.percentEncodedQuery
                if let formEncodedData = formEncodedString?.data(using: .utf8) {
                    self.httpBody = formEncodedData
                    self.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                } else {
                    print("error in \(urlString) with parameterEncoding \(parameterEncoding)")
                }
            }
        case .FormData:
            //https://stackoverflow.com/questions/26162616/upload-image-with-parameters-in-swift
            //https://orjpap.github.io/swift/http/ios/urlsession/2021/04/26/Multipart-Form-Requests.html
            //https://bhuvaneswarikittappa.medium.com/upload-image-to-server-using-multipart-form-data-in-ios-swift-5c4eb6de26e2
            
            let boundary = "Boundary-\(UUID().uuidString)"
            let lineBreak = "\r\n"
            
            var body = Data()
            
            if let parameters {
                parameters.forEach { key, value in
                    if let params = value as? JSONKeyPair, let data = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) {
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
            
            if let fileModel {
                for fileModel in fileModel {
                    body.appendString("--\(boundary + lineBreak)")
                    body.appendString("Content-Disposition: form-data; name=\"\(fileModel.fileKeyName)\"; filename=\"\(fileModel.fileName)\"\(lineBreak)")
                    body.appendString("Content-Type: \(fileModel.mimeType + lineBreak + lineBreak)")
                    body.append(fileModel.file)
                    body.appendString(lineBreak)
                }
            }
            
            body.appendString("--\(boundary)--\(lineBreak)")
            
            self.httpBody = body
            self.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            self.addValue("\(body.count)", forHTTPHeaderField: "Content-Length")
        }
    }
}
