//
//  APIError.swift
//  iOS_Basic_Structure
//
//  Created by Dhrumil Raval on 30/04/24.
//

import Foundation
struct ErrorResponse: Error,Codable {
    let success: Bool
    let message: String
    let error_code: String?
    let status_code: String?
}

/// An enumeration representing errors that can occur during API requests.
/// Conforms to the Error protocol for error handling and Comparable for sorting purposes.
enum APIError: Error, Comparable {
    
    /// Compares two APIError instances based on their localized descriptions.
    /// - Parameters:
    ///   - lhs: The left-hand side APIError to compare.
    ///   - rhs: The right-hand side APIError to compare.
    /// - Returns: A Boolean value indicating whether the lhs is less than rhs.
    static func < (lhs: APIError, rhs: APIError) -> Bool {
        return lhs.localizedDescription < rhs.localizedDescription
    }
    
    /// Checks equality between two APIError instances based on their localized descriptions.
    /// - Parameters:
    ///   - lhs: The left-hand side APIError to compare.
    ///   - rhs: The right-hand side APIError to compare.
    /// - Returns: A Boolean value indicating whether the two APIError instances are equal.
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
    
    /// An error representing an underlying error from the network operation.
    case underlying(Error)
    
    /// An error indicating that no HTTP response was received.
    case noResponse
    
    /// An error for invalid status codes (outside the 200-299 range).
    case statusCode(Int,errResponse: ErrorResponse)
    
    /// An error indicating that no data was found in the response.
    case noData
    
    /// An error that occurred during JSON decoding.
    case decoding(Error)
    
    /// An error indicating that the data format is not valid JSON.
    case invalidJSON
    
    /// An error indicating that access is unauthorized, possibly due to an expired access token.
    case unAuthorized(ErrorResponse)
    
    /// error shows message
    case custom(String)
    
    /// A localized description of the error.
    /// - Returns: A string providing a human-readable description of the error.
    var localizedDescription: String {
        switch self {
            case .underlying(_):
                return "Something Went Wrong"
            case .noResponse:
                return "No response received from the server."
            case .statusCode(let code, let response):
                return "\(response.message)"
            case .noData:
                return "No data found."
            case .decoding(_):
                return "Something Went Wrong while parsing data"
            case .invalidJSON:
                return "Invalid JSON format."
            case .unAuthorized(_):
                return "UnAuthorized"
            case .custom(let errorMessage):
                return errorMessage
        }
    }
}
