//
//  GenericParser.swift
//  iOS_Basic_SwiftUI_Structure
//
//  Created by Dhrumil on 13/05/25.
//

import Foundation

/// A generic parser class for parsing API responses into specified data types.
/// - T: The type of the object to decode from the response, constrained to `Decodable`.
class GenericParser<T: Decodable> {
    
    /// Parses the response data, checks for errors, and attempts to decode the data into an object of type T.
    /// - Parameters:
    ///   - data: The optional Data object received from the API response.
    ///   - response: The optional HTTPURLResponse object for additional response information.
    ///   - error: The optional Error object if an error occurred during the request.
    /// - Returns: A Result containing the decoded object of type T on success, or an APIError on failure.
    func parseResponse(from data: Data?, response: HTTPURLResponse?, error: Error?) -> Result<T, APIError> {
        // Handle potential errors
        if let error = error {
            debugPrint(error)
            return .failure(.underlying(error))
        }

        guard let response = response else {
            return .failure(.noResponse)
        }

        guard (200..<300).contains(response.statusCode) else {
            /// Handle Error's state for Production API's
            /// On Production we are getting all status codes
            /*
              OK = 200 - success
              CREATED = 201;  - success
              NO_CONTENT = 204;  - success
              BAD_REQUEST = 400; - fail - Bad request shows error message from response
              UNAUTHORIZED = 401; - UNAUTHORISED users which handle after decoder, error_code = E003
              NOT_FOUND = 404; fail
              NOT_ACCEPTABLE = 406; fail
              INTERNAL_SERVER_ERROR = 500; Server error
             }
             */
            debugPrint("Error-StatusCode:❌❌❌",response.statusCode)
            if let data = data, let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                if errorResponse.error_code == "E003" || errorResponse.status_code == "E003" {
                    debugPrint(errorResponse)
                    return .failure(.unAuthorized(errorResponse))
                } else if (errorResponse.success  && errorResponse.message == "No data found.") {
                    debugPrint(errorResponse)
                    return .failure(.noData) // Handle no data scenario
                } else if (400..<500).contains(response.statusCode) {
                    return .failure(.statusCode(response.statusCode, errResponse: errorResponse))
                } else if (!errorResponse.success && errorResponse.message != "" ) {
                    return .failure(.custom(errorResponse.message))
                }
            }
            return .failure(.custom(response.description))
        }

        guard let data = data else {
            return .failure(.noData)
        }

        // Attempt to decode the data
        do {
            let decoder = JSONDecoder()
            
            // Decode the successful response into the specified type T
            let decodedObject = try decoder.decode(T.self, from: data)
         //   debugPrint(decodedObject)
            return .success(decodedObject)
        } catch {
            debugPrint("\(#function) \(error)")
            return .failure(.decoding(error)) // Handle decoding errors
        }
    }
}
