//
//  APIManager.swift

import Foundation
import Alamofire

/// An enumeration representing different API requests that the application can make.
enum APIManager {
    case getObjects
    case postObject(param: [String:Any])
}

extension APIManager {
    
    /// A tuple containing the base URL and HTTP method for the API request.
    fileprivate var urlAndMethod: (String, Alamofire.HTTPMethod) {
        switch self {
            case .getObjects:
                return (Constants.baseURL, .get)
            case .postObject:
                return (Constants.baseURL, .post)
        }
    }
    
    /// The API version string used for certain endpoints.
    var apiVersion: String {
        switch self {
            case .getObjects, .postObject:
                return ""
            default:
                return ""
        }
    }
    
    /// A tuple containing the endpoint path and parameters for the API request.
    var endPoint: (path: String, params: [String: Any]?) {
        switch self {
            case .getObjects:
                return ("objects",nil)
            case .postObject(let param):
                return ("objects", param)
        }
    }
    
}


extension APIManager: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let (baseURL, httpMethod) = urlAndMethod
        let strURL: String = baseURL + apiVersion + endPoint.path
        guard let url = URL(string: strURL) else {
            fatalError("Request URL invalid for \(self)")
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        // Set headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        // Encode parameters as JSON for POST requests
        switch httpMethod {
            case .post:
                switch self {
                    case .postObject:
                        //POST JSON request paramaters
                        
                        request.setValue("Bearer \("")", forHTTPHeaderField: "Authorization") // Use appropriate token value
                        
                        request = try JSONEncoding.default.encode(request, with: endPoint.params)
                        
                        /*  case //if Post with MultiPart data - Like Upload image:
                         if let params = endPoint.params {
                         let boundary = UUID().uuidString
                         request.setValue("Bearer \(UserDefaultsConfig.accessToken)", forHTTPHeaderField: "Authorization") // Use appropriate token value
                         request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                         
                         if let imgData = params["image"] as? Data, let strFileName = params["file_name"] as? String {
                         if strFileName.contains(".pdf") {
                         request.httpBody = appendPDFDataToBody(parameters: params, mediaData: imgData, boundary: boundary, fileName: strFileName)
                         } else {
                         request.httpBody = appendMediaDataToBody(parameters: params, mediaData: imgData, boundary: boundary, fileName: strFileName)
                         }
                         }
                         else {
                         request.httpBody = createMultipartBody(parameters: params, boundary: boundary)
                         }
                         } */
                    default:
                        debugPrint("\(#function) Unaware request type please check request method")
                        break
                }
                
            case .get:
                switch self {
                    case .getObjects:
                        //Get query parameters
                        request.setValue("Bearer \("")", forHTTPHeaderField: "Authorization") // Use appropriate token value
                        
                        if let params = endPoint.params {
                            request = try URLEncoding.queryString.encode(request, with: params)
                        } else {
                            request = try URLEncoding.queryString.encode(request, with: nil)
                        }
                    default:
                        debugPrint("\(#function) Unknown request type please check request method")
                        break
                }
            default:
                debugPrint("\(#function) Unknown request type please check request method")
        }
        dump("Requested URL➡️➡️➡️➡️➡️ : \(httpMethod) \(url.absoluteString)\nParameters: \(endPoint.params ?? [:]) \nHeaders: \(request.allHTTPHeaderFields ?? [:])")
        return request
    }
}

/// Creates a multipart body for the request.
/// - Parameters:
///   - parameters: A dictionary containing the parameters to be included in the body.
///   - boundary: A string used to separate different parts of the form data.
/// - Returns: The created multipart body as Data.
private func createMultipartBody(parameters: [String: Any], boundary: String) -> Data {
    var body = Data()
    
    for (key, value) in parameters {
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(value)\r\n".data(using: .utf8)!)
    }
    
    body.append("--\(boundary)--\r\n".data(using: .utf8)!)
    return body
}

/// Creates a multipart body for the request that includes media data.
/// - Parameters:
///   - parameters: A dictionary containing the parameters to be included in the body.
///   - mediaData: The binary data of the media file (e.g., image) to be uploaded.
///   - boundary: A string used to separate different parts of the form data.
///   - dataParameterName: The name of the media data parameter (default is "image").
///   - fileName: The name of the file being uploaded.
/// - Returns: The created multipart body as Data.
private func appendMediaDataToBody(parameters: [String: Any], mediaData: Data, boundary: String, dataParameterName: String = "image", fileName: String) -> Data {
    var body = Data()
    for (key, value) in parameters {
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(value)\r\n".data(using: .utf8)!)
    }
    
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"\(dataParameterName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
    body.append(mediaData)
    body.append("\r\n".data(using: .utf8)!)
    body.append("--\(boundary)--\r\n".data(using: .utf8)!)
    return body
}

private func appendPDFDataToBody(parameters: [String: Any], mediaData: Data, boundary: String, dataParameterName: String = "image", fileName: String) -> Data {
    var body = Data()
    for (key, value) in parameters {
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(value)\r\n".data(using: .utf8)!)
    }
    
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"\(dataParameterName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: pdf\r\n\r\n".data(using: .utf8)!)
    body.append(mediaData)
    body.append("\r\n".data(using: .utf8)!)
    body.append("--\(boundary)--\r\n".data(using: .utf8)!)
    return body
}
