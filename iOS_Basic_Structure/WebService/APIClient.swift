//
//  ApiCallManager.swift

import Combine
import Alamofire
import Foundation

/// A singleton class responsible for making API requests and handling network communication.
class APIClient: NSObject {
    
    /// The shared instance of the APIClient for global access.
    internal static let shared = APIClient()
    
    /// An instance of the ConnectivityViewModel to check internet connectivity.
    private let connectivityViewModel = ConnectivityViewModel()
    
    /// A typealias for a success handler that takes a generic Codable type.
    internal typealias SuccessHandler<T: Codable> = ((T) -> Void)
    
    /// A typealias for a failure handler that takes an APIError.
    internal typealias FailureHandler = ((APIError) -> Void)
    
    /// Sends a network request and handles the response as an object of type T.
    /// - Parameters:
    ///   - request: An instance of APIManager that conforms to the API request configuration.
    ///   - completion: A closure that is called with the successfully parsed object of type T.
    ///   - errorBlock: A closure that is called with an APIError if the request fails.
    func requestObject<T: Codable>(_ request: APIManager, completion: SuccessHandler<T>?, errorBlock: FailureHandler?) {
        //Check for Internet Connection
        if !connectivityViewModel.isConnectedToInternet {
            connectivityViewModel.showNoInternetView = true
            return
        }
        
        do {
            let urlRequest = try request.asURLRequest()
            AF.request(urlRequest)
                .responseData { response in
                    let parser = GenericParser<T>()
                    let result = parser.parseResponse(from: response.data, response: response.response, error: response.error)
                    
                    switch result {
                        case let .success(data):
                            dump("\(#function):🔥🔥🔥 \(data.dictionary ?? [:] )")
                            completion?(data)
                        case let .failure(error):
                            errorBlock?(error)
                    }
                }
        } catch {
            errorBlock?(.underlying(error))
        }
    }
    
    /// Sends a network request and returns a publisher for the response object.
    /// - Parameter request: An instance of APIManager that conforms to the API request configuration.
    /// - Returns: A publisher that emits the parsed object of type T or an APIError on failure.
    func requestObjectPublisher<T: Codable>(_ request: APIManager) -> AnyPublisher<T, APIError> {
        Future { promise in
            self.requestObject(request) { (response: T) in
                promise(.success(response))
            } errorBlock: { error in
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
