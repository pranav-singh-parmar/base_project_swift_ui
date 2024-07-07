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
enum APIError: Error {
    case internetNotConnected,
         mapError,
         invalidHTTPURLResponse,
         informationalError(Int),
         decodingError,
         redirectionalError(Int),
         clientError(ClientErrorsEnum),
         serverError(Int),
         unknown(Int)
}

enum ClientErrorsEnum: Int {
    case badRequest = 400,
         unauthorized = 401,
         paymentRequired = 402,
         forbidden = 403,
         notFound = 404,
         methodNotAllowed = 405,
         notAcceptable = 406,
         uriTooLong = 414,
         other
}
