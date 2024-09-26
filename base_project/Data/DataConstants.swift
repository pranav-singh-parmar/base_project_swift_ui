//
//  DataConstants.swift
//  base_project
//
//  Created by Pranav Singh on 07/07/24.
//

import Foundation

//MARK: - Enums
enum HTTPMethod: String {
    case get, post, put, delete
}

enum MimeTypeEnum: String {
    case json = "application/json",
         text = "text/plain",
         html = "text/html"
}

enum ParameterEncodingEnum {
    case json,
         urlFormEncoded,
         multipartFormData(withBoundary: String, andCount: Int)
}

//MARK: - Error Enums
enum URLRequestError: Error {
    case invalidURL,
         invalidQueryParameters
}

//https://developer.mozilla.org/en-US/docs/Web/HTTP/Status#server_error_responses
//Informational responses (100-199)
//Successful responses (200–299)
//Redirection messages (300–399)
//Client error responses (400–499)
//Server error responses (500–599)
enum APIRequestError: Error {
    case internetNotConnected,
         invalidHTTPURLResponse,
         timedOut,
         networkConnectionLost,
         urlError(errorCode: Int),
         missingMimeType,
         mimeTypeMismatched,
         informationalError(statusCode: Int),
         redirectionalError(statusCode: Int),
         clientError(ClientErrorsEnum),
         serverError(statusCode: Int),
         unknown(statusCode: Int)
}

enum ClientErrorsEnum {
    case badRequest,//400
         unauthorised,//401
         paymentRequired,//402
         forbidden,//403
         notFound,//404
         methodNotAllowed,//405
         notAcceptable,//406
         uriTooLong,//414
         other(Int)
    
    static func getCorrespondingValue(forStatusCode statusCode: Int) -> ClientErrorsEnum {
        switch statusCode {
        case 400:
            return .badRequest
        case 401:
            return .unauthorised
        case 402:
            return .paymentRequired
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 405:
            return .methodNotAllowed
        case 406:
            return .notAcceptable
        case 414:
            return .uriTooLong
        default:
            return .other(statusCode)
        }
    }
}

enum DataSourceError: Error {
    case urlRequestError(URLRequestError),
         //error and error message
         apiRequestError(APIRequestError, String?),
         decodingError
}

enum RepositoryError: Error {
    case dataSourceError(DataSourceError)
}

//MARK: - Result Enums
@frozen
enum APIRequestResult<Success, Failure> where Failure : Error {
    
    /// A success, storing a `Success` value.
    case success(statusCode: Int, Success)
    
    /// A failure, storing a `Failure` value.
    case failure(Failure, Data?)
}

@frozen
enum DownloadRequestResult<Success, Failure> where Failure : Error {
    
    /// A success, storing a `Success` value.
    case success(statusCode: Int, Success)
    
    /// A failure, storing a `Failure` value.
    case failure(Failure)
}

@frozen
enum DataSourceResult<Success, Failure> where Failure : Error {
    
    /// A success, storing a `Success` value.
    case success(Success)
    
    /// A failure, storing a `Failure` value.
    case failure(Failure)
}
