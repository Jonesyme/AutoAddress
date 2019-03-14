//
//  APIClient.swift
//  AutoAddress
//
//  Created by Mike Jones on 3/13/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import Foundation

// generic API errors
public enum APIError: Error {
    case unknownError
    case badResponse(Int)
    case networkError(Error)
    case parseError(Error)
    
    var localizedDescription: String {
        switch self {
        case .unknownError: return "Unknown networking error"
        case .badResponse(let code): return "Bad response code: \(code)"
        case .networkError(let error): return "Network error: " + error.localizedDescription
        case .parseError(let error): return "Error parsing JSON: \(error)"
        }
    }
}

// generic API response object
public enum APIResponse<T:Decodable> {
    case result(T)
    case error(APIError)
}
// generic API completion handler
public typealias APIRequestCompletion<T:Decodable> = (APIResponse<T>) -> Void


// singleton APIClient
final public class APIClient {
    
    // singleton
    private static var sharedAPIClient: APIClient = {
        let apiClient = APIClient()
        return apiClient
    }()
    
    // public accessor
    class func shared() -> APIClient {
        return sharedAPIClient
    }

    // shared session
    static let ApiSession : URLSession = {
        var configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = true
        let session = URLSession(configuration: configuration)
        return session
    }()
}

// MARK: - Giphy API Client
extension APIClient {
    
    internal func generateURL(_ endpoint: DWSEndpoint) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        
        var queryItems = endpoint.params
        queryItems.append(endpoint.apiCode)
        urlComponents.queryItems = queryItems

        return urlComponents.url
    }
    
    public func get<T:Decodable>(_ endpoint: DWSEndpoint, responseType: T.Type, callback: @escaping APIRequestCompletion<T>) {
        guard let requeustURL = generateURL(endpoint) else {
            callback(.error(APIError.unknownError))
            return
        }
        
        APIClient.ApiSession.dataTask(with: requeustURL) { (data, response, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    callback(.error(APIError.networkError(error!)))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    callback(.error(APIError.badResponse(-1)))
                }
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    callback(.error(APIError.badResponse(httpResponse.statusCode)))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    callback(.error(APIError.unknownError))
                }
                return
            }
            
            let decoded: DWSEndpoint.DecodeResult<T> = endpoint.decode(withJSON: data, decodingType: T.self)
            
            DispatchQueue.main.async {
                switch decoded {
                case .success(let result):
                    callback(.result(result))
                case .error(let error):
                    callback(.error(.parseError(error)))
                }
            }
        }.resume()
    }
}
