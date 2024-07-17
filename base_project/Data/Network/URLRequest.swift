//
//  ApiServices.swift
//  base_project
//
//  Created by Pranav Singh on 01/08/22.
//

import Foundation
import Network
import Combine

extension URLRequest {
    
    private static let apiErrorTAG = "APIError:"
    
    var getURLString: String {
        return self.url?.absoluteString ?? "URL not set"
    }
    
    //MARK: - Initializers
    init?(ofHTTPMethod httpMethod: HTTPMethod,
          forAppEndpoint appEndpoint: AppEndpoints,
          withQueryParameters queryParameters: JSONKeyPair?) {
        self.init(withHTTPMethod: httpMethod,
                  forAppEndpoint: appEndpoint,
                  withQueryParameters: queryParameters)
    }
    
    init?(ofHTTPMethod httpMethod: HTTPMethod,
          forAppEndpoint appEndpoint: AppEndpointsWithParamters,
          withQueryParameters queryParameters: JSONKeyPair?) {
        self.init(withHTTPMethod: httpMethod,
                  forAppEndpoint: appEndpoint,
                  withQueryParameters: queryParameters)
    }
    
    private init?(withHTTPMethod httpMethod: HTTPMethod,
                  forAppEndpoint appEndpoint: EndpointsProtocol,
                  withQueryParameters queryParameters: JSONKeyPair?) {
        let urlString = appEndpoint.getURLString()
        guard let url = URL(string: urlString) else {
            print(URLRequest.apiErrorTAG, "Cannot Initiate URL with String", urlString)
            return nil
        }
        
        self.init(url: url)
        printRequestDetailsTag(isStarted: true)
        if let queryParameters {
            let urlComponents = getQueryItems(withParamters: queryParameters)
            if let url = urlComponents?.url {
                self.url = url
            }
            print("Query Paramters:", queryParameters)
            print("URL with Query Parameter:", self.getURLString)
        }
        self.httpMethod = httpMethod.rawValue
        print("HTTP Method:", self.httpMethod ?? "http method not assigned")
    }
    
    //MARK: - Query Parameters
    private func getQueryItems(withParamters parameters: JSONKeyPair) -> URLComponents? {
        var urlComponents = URLComponents(string: self.getURLString)
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
    
    //MARK: - Headers
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
    
    //MARK: - Parameters
    mutating func addParameters(_ parameters: JSONKeyPair?, withFileModel fileModel: [FileModel]? = nil, as parameterEncoding: ParameterEncoding) {
        let urlString = self.getURLString
        switch parameterEncoding {
        case .jsonBody:
            if let parameters {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                    self.httpBody = jsonData
                    self.addValue("application/json", forHTTPHeaderField: "Content-Type")
                } catch {
                    print("error in \(urlString) with parameterEncoding \(parameterEncoding)", error.localizedDescription)
                }
            }
        case .urlFormEncoded:
            if let parameters {
                let urlComponents = self.getQueryItems(withParamters: parameters)
                let formEncodedString = urlComponents?.percentEncodedQuery
                if let formEncodedData = formEncodedString?.data(using: .utf8) {
                    self.httpBody = formEncodedData
                    self.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                } else {
                    print("error in \(urlString) with parameterEncoding \(parameterEncoding)")
                }
            }
        case .formData:
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
            
            print("ParameterEncoding:", parameterEncoding)
            print("Parameters:", parameters ?? [:])
            print("Body Data:", self.httpBody ?? Data())
        }
    }
    
    //MARK: - Hit API
    func sendAPIRequest() async -> (Data?, Error?) {
        
        print("Headers:", self.allHTTPHeaderFields ?? [:])
        printRequestDetailsTag(isStarted: false)
        
        guard Singleton.sharedInstance.appEnvironmentObject.isConnectedToInternet else {
            return (nil, printAndReturnAPIRequestError(.internetNotConnected))
        }
        
        do {
            let (data, response) = try await URLSession
                .shared
                .data(for: self)
            
            printResponseDetailsTag(isStarted: true)
            
            guard let response = response as? HTTPURLResponse else {
                return (data, printAndReturnAPIRequestError(.invalidHTTPURLResponse))
            }
            
            #if DEBUG
            let jsonConvert = try? JSONSerialization.jsonObject(with: data, options: [])
            let json = jsonConvert as AnyObject
            print("Json Response:")
            print(json)
            #endif
            
            guard let mimeType = response.mimeType, mimeType == "application/json" else {
                print("Wrong MIME type!", response.mimeType ?? "")
                
                let paragraphs = String(data: data, encoding: .utf8)!.components(separatedBy: .newlines)
                print("Data received from API", paragraphs)
                
                return (data, printAndReturnAPIRequestError(.invalidMimeType))
            }
            
            switch response.statusCode {
            case 100...199:
                return (data, printAndReturnAPIRequestError(.informationalError(response.statusCode)))
            case 200...299:
                printResponseDetailsTag(isStarted: false)
                return (data, nil)
                
//#if DEBUG
//                if let _ = data.toStruct(decodingStruct) {
//                    printResponseDetailsTag(isStarted: false)
//                }
//#endif
//                return Just(data)
//                    .decode(type: decodingStruct.self,
//                            decoder: Singleton.sharedInstance.jsonDecoder)
//                    .mapError { _ in
//                        self.printApiError(.decodingError)
//                        return APIError.decodingError
//                    }
//                    .eraseToAnyPublisher()
                
            case 300...399:
                return (data, printAndReturnAPIRequestError(.redirectionalError(response.statusCode)))
            case 400...499:
                let clientErrorEnum = ClientErrorsEnum.getCorrespondingValue(forStatusCode: response.statusCode)
                switch clientErrorEnum {
                case .unauthorized:
                    Singleton.sharedInstance.alerts.handle401StatueCode()
                case .badRequest, .paymentRequired, .forbidden, .notFound, .methodNotAllowed, .notAcceptable, .uriTooLong, .other:
                    if let message = json["message"] as? String {
                        Singleton.sharedInstance.alerts.errorAlertWith(message: message)
                    } else if let errorMessage = json["error"] as? String {
                        Singleton.sharedInstance.alerts.errorAlertWith(message: errorMessage)
                    } else if let errorMessages = json["error"] as? [String] {
                        var errorMessage = ""
                        for message in errorMessages {
                            if errorMessage != "" {
                                errorMessage = errorMessage + ", "
                            }
                            errorMessage = errorMessage + message
                        }
                        Singleton.sharedInstance.alerts.errorAlertWith(message: errorMessage)
                    } else{
                        Singleton.sharedInstance.alerts.errorAlertWith(message: "Server Error")
                    }
                }
                return (data, printAndReturnAPIRequestError(.clientError(clientErrorEnum, response.statusCode)))
            case 500...599:
                return (data, printAndReturnAPIRequestError(.serverError(response.statusCode)))
            default:
                return (data, self.printAndReturnAPIRequestError(.unknown(response.statusCode)))
            }
        } catch let error {
            return (nil, error)
//               let urlError = underlyingError as? URLError {
//                case .timedOut:
//                    self.ShowErrorOnTokenExpire(errorCode: StringConstants.inconvenience.localized)
//                    Loader.shared.hideLoader()
//                    print("-----URL Response Details Ends-----\n")
//                    //                                           UtilitiesHelper.ShowAlertOfValidation(OfMessage: StringConstants.requestTimeOut.localized)
//                    completion?(nil, JSON(error),error)
//                case .notConnectedToInternet:
//                    UtilitiesHelper.ShowAlertOfValidation(OfMessage: StringConstants.internetConnection.localized)
//                    Loader.shared.hideLoader()
//                    print("-----URL Response Details Ends-----\n")
//                    completion?(nil, JSON(error),error)
//                case .networkConnectionLost:
//                    //reloads the api if network connection lost
//                    print("-----URL Response Details Ends-----")
//                    print("Same API will be called again now\n")
        }
        //        } else {
        //            let monitor = NWPathMonitor()
        //            let queue = DispatchQueue(label: self.getURLString)
        //            monitor.pathUpdateHandler = { path in
        //                DispatchQueue.main.async {
        //                    if path.status == .satisfied {
        //                        outputBlockForInternetNotConnected()
        //                        monitor.cancel()
        //                    }
        //                }
        //            }
        //            monitor.start(queue: queue)
        //            return getApiErrorPublisher(.internetNotConnected)
        //        }
    }
    
    //MARK: - Error Publishers
    private func printAndReturnAPIRequestError(_ apiError: APIRequestError) -> APIRequestError {
        printApiError(apiError)
        return apiError
    }
    
    private func printApiError(_ apiError: APIRequestError) {
        print(URLRequest.apiErrorTAG, "\(apiError)")
        if apiError.localizedDescription != APIError.internetNotConnected.localizedDescription {
            printResponseDetailsTag(isStarted: false)
        }
    }
    
    private func printRequestDetailsTag(isStarted: Bool) {
        if isStarted {
            print("\n-----URL Request Details Starts-----")
            print("URL:", self.getURLString)
        } else {
            print("-----URL Request Details Ends-----\n")
        }
    }
    
    private func printResponseDetailsTag(isStarted: Bool) {
        if isStarted {
            print("\n-----URL Response Details Starts-----")
            print("URL:", self.getURLString)
        } else {
            print("-----URL Response Details Ends-----\n")
        }
    }
}
