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

enum ParameterEncoding: String {
    case jsonBody, urlFormEncoded, formData
}

//https://developer.mozilla.org/en-US/docs/Web/HTTP/Status#server_error_responses
//Informational responses (100-199)
//Successful responses (200–299)
//Redirection messages (300–399)
//Client error responses (400–499)
//Server error responses (500–599)
enum APIRequestError: Error {
    case internetNotConnected,
         invalidURL,
         invalidHTTPURLResponse,
         invalidMimeType,
         informationalError(Int),
         redirectionalError(Int),
         clientError(ClientErrorsEnum, Int),
         serverError(Int),
         unknown(Int)
}

enum ClientErrorsEnum {
    case badRequest,
         unauthorized,
         paymentRequired,
         forbidden,
         notFound,
         methodNotAllowed,
         notAcceptable,
         uriTooLong,
         other
    
    static func getCorrespondingValue(forStatusCode statusCode: Int) -> ClientErrorsEnum {
        switch statusCode {
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
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
            return .other
        }
    }
}

enum DataSourceError: Error {
    case apiRequestError(APIRequestError),
         invalidURL,
         decodingError,
         unknown
}

enum RepositoryError: Error {
    case dataSourceError(DataSourceError)
}
