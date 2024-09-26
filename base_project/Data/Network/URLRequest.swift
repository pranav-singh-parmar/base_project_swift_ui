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
    
    //MARK: - Initialisers
    init(ofHTTPMethod httpMethod: HTTPMethod,
         forBreakingBadEndpoint breakingBadEndpoint: BreakingBadEndpoints,
         withQueryParameters queryParameters: JSONKeyValuePair? = nil) throws {
        do {
            try self.init(ofHTTPMethod: httpMethod,
                          forEndpoint: breakingBadEndpoint,
                          withQueryParameters: queryParameters)
        } catch {
            throw error
        }
    }
    
    init(ofHTTPMethod httpMethod: HTTPMethod,
         forAnimeEndpoint animeEndpoint: AnimeAPIEndpoints,
         withQueryParameters queryParameters: JSONKeyValuePair? = nil) throws {
        do {
            try self.init(ofHTTPMethod: httpMethod,
                          forEndpoint: animeEndpoint,
                          withQueryParameters: queryParameters)
        } catch {
            throw error
        }
    }
    
    private init(ofHTTPMethod httpMethod: HTTPMethod,
                 forEndpoint appEndpoint: APIEndpointsProtocol,
                 withQueryParameters queryParameters: JSONKeyValuePair? = nil) throws { //throws(APIRequestError) to be in Swift6
        let urlString = appEndpoint.getURLString()
        guard let url = URL(string: urlString) else {
            //print(URLRequest.apiErrorTAG, "Cannot Initiate URL with String", urlString)
            throw URLRequestError.invalidURL
        }
        
        self.init(url: url)
        if let queryParameters {
            let urlComponents = getURLComponents(withQueryParameters: queryParameters)
            guard let url = urlComponents?.url else {
                throw URLRequestError.invalidQueryParameters
            }
            
            self.url = url
            printRequestDetailsTag(isStarted: true)
            print("Query Parameters:")
            print(queryParameters.toJSONStringFormat() ?? "")
            print("URL with Query Parameter:", self.getURLString)
        } else {
            printRequestDetailsTag(isStarted: true)
        }
        self.httpMethod = httpMethod.rawValue
        print("HTTP Method:", self.httpMethod ?? "http method not assigned")
    }
    
    //MARK: - URLComponents
    private func getURLComponents(withQueryParameters queryParameters: JSONKeyValuePair) -> URLComponents? {
        var urlComponents = URLComponents(string: self.getURLString)
        urlComponents?.queryItems = []
        for (key, value) in queryParameters {
            urlComponents?.queryItems?.append(URLQueryItem(name: key, value: "\(value)"))
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
    mutating func addHeader(withKey key: String, andValue value: String) {
        self.addValue(value, forHTTPHeaderField: key)
    }
    
    mutating func requestResponse(in mimeType: MimeTypeEnum) {
        self.addHeader(withKey: "Accept", andValue: mimeType.rawValue)
    }
    
    mutating func addAuthorisationToken(_ token: String) {
        self.addHeader(withKey: "Authorisation", andValue: token)
    }
    
    private mutating func setContentTypeHeader(to contentTypeEnum: ParameterEncodingEnum) {
        let keyName = "Content-Type"
        switch contentTypeEnum {
        case .json:
            self.addHeader(withKey: keyName, andValue: MimeTypeEnum.json.rawValue)
        case .urlFormEncoded:
            self.addHeader(withKey: keyName, andValue: "application/x-www-form-urlencoded")
        case .multipartFormData(let boundary, let count):
            self.addHeader(withKey: keyName, andValue:  "multipart/form-data; boundary=\(boundary)")
            self.addHeader(withKey: "Content-Length", andValue: "\(count)")
        }
    }
    
    mutating func addHeaders(_ headers: [String: String]) {
        headers.forEach { key, value in
            self.addHeader(withKey: key, andValue: value)
        }
    }
    
    //create url enum type
    mutating func setHeadersFor(_ serverURL: ServerURLs,
                                requestingResponseIn requestMimeType: MimeTypeEnum = .json) {
        self.requestResponse(in: requestMimeType)
        self.addHeader(withKey: "device", andValue: "iOS")
        
        switch serverURL {
        case .breakingBad(_):
            break
        case .anime(_):
            let headers = ["X-RapidAPI-Key": "2b975442demsh14dd8bb5a692b60p17c702jsnc458dbd221ae",
                           "X-RapidAPI-Host": "anime-db.p.rapidapi.com"] as [String: String]
            self.addHeaders(headers)
        }
    }
    
    func getHeaderValueForKey(_ key: String) -> String? {
        return self.allHTTPHeaderFields?.first(where: { $0.key == key })?.value
    }
    
    //MARK: - Parameters
    mutating func addParameters(_ parameters: JSONKeyValuePair?,
                                withFileModel fileModel: [FileModel]? = nil,
                                as parameterEncoding: ParameterEncodingEnum) {
        let urlString = self.getURLString
        switch parameterEncoding {
        case .json:
            if let parameters {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                    self.httpBody = jsonData
                    self.setContentTypeHeader(to: .json)
                } catch {
                    print("error in \(urlString) with parameterEncoding \(parameterEncoding)", error.localizedDescription)
                }
            }
        case .urlFormEncoded:
            if let parameters {
                let urlComponents = self.getURLComponents(withQueryParameters: parameters)
                let formEncodedString = urlComponents?.percentEncodedQuery
                if let formEncodedData = formEncodedString?.data(using: .utf8) {
                    self.httpBody = formEncodedData
                    self.setContentTypeHeader(to: .urlFormEncoded)
                } else {
                    print("error in \(urlString) with parameterEncoding \(parameterEncoding)")
                }
            }
        case .multipartFormData:
            //https://stackoverflow.com/questions/26162616/upload-image-with-parameters-in-swift
            //https://orjpap.github.io/swift/http/ios/urlsession/2021/04/26/Multipart-Form-Requests.html
            //https://bhuvaneswarikittappa.medium.com/upload-image-to-server-using-multipart-form-data-in-ios-swift-5c4eb6de26e2
            
            let boundary = "Boundary-\(UUID().uuidString)"
            let lineBreak = "\r\n"
            
            var body = Data()
            
            if let parameters {
                parameters.forEach { key, value in
                    if let params = value as? JSONKeyValuePair, let data = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) {
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
            self.setContentTypeHeader(to: .multipartFormData(withBoundary: boundary, andCount: body.count))
        }
        
        print("ParameterEncoding:", parameterEncoding)
        #if DEBUG
        if let parameters {
            print("Parameters:")
            print(parameters.toJSONStringFormat() ?? "")
        }
        #endif
        print("Body Data:", self.httpBody ?? Data())
    }
    
    //MARK: - Hit API
    func sendAPIRequest() async -> APIRequestResult<Data, APIRequestError> {
        
        printHeaders()
        printRequestDetailsTag(isStarted: false)
        
        guard Singleton.sharedInstance.appEnvironmentObject.isConnectedToInternet else {
            return .failure(printAndReturnAPIRequestError(.internetNotConnected), nil)
        }
        
        do {
            let (data, response) = try await URLSession
                .shared
                .data(for: self)
            
            printResponseDetailsTag(isStarted: true)
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(printAndReturnAPIRequestError(.invalidHTTPURLResponse), data)
            }
            print("Status Code:", response.statusCode)
            
            guard let mimeType = response.mimeType else {
                return .failure(printAndReturnAPIRequestError(.missingMimeType), data)
            }
            
            if let accept = self.getHeaderValueForKey("Accept"),
               accept != mimeType {
                print("Wrong MIME type!")
                print("Accept Key sent in header:", accept)
                print("MimeType received in Response:", mimeType)
                
                if let paragraphs = String(data: data, encoding: .utf8)?.components(separatedBy: .newlines) {
                    print("Data received from API:")
                    for line in paragraphs {
                        print(line)
                    }
                } else {
                    print("Default Message: Not able to read data")
                }
                
                return .failure(printAndReturnAPIRequestError(.mimeTypeMismatched), data)
            }
            
            #if DEBUG
            do {
                let jsonConvert = try JSONSerialization.jsonObject(with: data, options: [])
                let json = jsonConvert as? [String: Any]
                if let json = jsonConvert as? JSONKeyValuePair {
                    print(json.toJSONStringFormat() ?? "")
                } else if let jsonArray = jsonConvert as? [JSONKeyValuePair] {
                    print(jsonArray.toJSONStringFormat() ?? "")
                } else {
                    print("Response is neither Json, nor array of Json")
                }
            } catch {
                print("Can't Fetch JSON Response:", error)
            }
            #endif
            
            switch response.statusCode {
            case 100...199:
                return .failure(printAndReturnAPIRequestError(.informationalError(statusCode: response.statusCode)), data)
            case 200...299:
                printResponseDetailsTag(isStarted: false)
                return .success(statusCode: response.statusCode, data)
            case 300...399:
                return .failure(printAndReturnAPIRequestError(.redirectionalError(statusCode: response.statusCode)), data)
            case 400...499:
                let clientErrorEnum = ClientErrorsEnum.getCorrespondingValue(forStatusCode: response.statusCode)
                return .failure(printAndReturnAPIRequestError(.clientError(clientErrorEnum)), data)
            case 500...599:
                return .failure(printAndReturnAPIRequestError(.serverError(statusCode: response.statusCode)), data)
            default:
                return .failure(printAndReturnAPIRequestError(.unknown(statusCode: response.statusCode)), data)
            }
        } catch let error {
            printResponseDetailsTag(isStarted: true)
            print("Error Localised Description:", error.localizedDescription)
            let errorCode = (error as NSError).code
            switch errorCode {
            case NSURLErrorTimedOut:
                return .failure(printAndReturnAPIRequestError(.timedOut), nil)
            case NSURLErrorNotConnectedToInternet:
                return .failure(printAndReturnAPIRequestError(.internetNotConnected), nil)
            case NSURLErrorNetworkConnectionLost:
                return .failure(printAndReturnAPIRequestError(.networkConnectionLost), nil)
            default:
                return .failure(printAndReturnAPIRequestError(.urlError(errorCode: errorCode)), nil)
            }
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
    
    func downloadFile() async -> DownloadRequestResult<URL, APIRequestError> {
        
        printHeaders()
        printRequestDetailsTag(isStarted: false)
        
        guard Singleton.sharedInstance.appEnvironmentObject.isConnectedToInternet else {
            return .failure(printAndReturnAPIRequestError(.internetNotConnected))
        }
        
        do {
            let (location, response) = try await URLSession
                .shared
                .download(for: self)
            
            printResponseDetailsTag(isStarted: true)
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(printAndReturnAPIRequestError(.invalidHTTPURLResponse))
            }
            print("Status Code:", response.statusCode)
            
            //            guard let mimeType = response.mimeType, mimeType == "application/json" else {
            //                print("Wrong MIME type!", response.mimeType ?? "")
            //
            //                if let paragraphs = String(data: data, encoding: .utf8)?.components(separatedBy: .newlines) {
            //                    print("Data received from API:")
            //                    for line in paragraphs {
            //                        print(line)
            //                    }
            //                } else {
            //                    print("Default Message: Not able to read data")
            //                }
            //
            //                return .failure(printAndReturnAPIRequestError(.invalidMimeType), data)
            //            }
            
            switch response.statusCode {
            case 100...199:
                return .failure(printAndReturnAPIRequestError(.informationalError(statusCode: response.statusCode)))
            case 200...299:
                printResponseDetailsTag(isStarted: false)
                return .success(statusCode: response.statusCode, location)
            case 300...399:
                return .failure(printAndReturnAPIRequestError(.redirectionalError(statusCode: response.statusCode)))
            case 400...499:
                let clientErrorEnum = ClientErrorsEnum.getCorrespondingValue(forStatusCode: response.statusCode)
                return .failure(printAndReturnAPIRequestError(.clientError(clientErrorEnum)))
            case 500...599:
                return .failure(printAndReturnAPIRequestError(.serverError(statusCode: response.statusCode)))
            default:
                return .failure(printAndReturnAPIRequestError(.unknown(statusCode: response.statusCode)))
            }
        } catch let error {
            printResponseDetailsTag(isStarted: true)
            print("Error Localised Description:", error.localizedDescription)
            let errorCode = (error as NSError).code
            switch errorCode {
            case NSURLErrorTimedOut:
                return .failure(printAndReturnAPIRequestError(.timedOut))
            case NSURLErrorNotConnectedToInternet:
                return .failure(printAndReturnAPIRequestError(.internetNotConnected))
            case NSURLErrorNetworkConnectionLost:
                return .failure(printAndReturnAPIRequestError(.networkConnectionLost))
            default:
                return .failure(printAndReturnAPIRequestError(.urlError(errorCode: errorCode)))
            }
        }
    }
    
    //MARK: - Print Related Functions
    private func printHeaders() {
        print("Headers:")
        print((self.allHTTPHeaderFields as JSONKeyValuePair?)?.toJSONStringFormat() ?? "")
    }
    
    private func printAndReturnAPIRequestError(_ apiError: APIRequestError) -> APIRequestError {
        printApiError(apiError)
        return apiError
    }
    
    private func printApiError(_ apiError: APIRequestError) {
        print(URLRequest.apiErrorTAG, "\(apiError)")
        if apiError.localizedDescription != APIRequestError.internetNotConnected.localizedDescription {
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
