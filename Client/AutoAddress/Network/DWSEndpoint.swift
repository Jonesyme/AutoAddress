//
//  DWSEndpoints.swift
//  AutoAddress
//
//  Created by Mike Jones on 3/13/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import Foundation

// dreamware endpoint list
public enum DWSEndpoint {
    
    case search(text: String)     // location search (auto-complete)
    case details(placeID: String) // fetch details for placeID
    
    enum DecodeResult<T:Decodable> {
        case success(T)
        case error(Error)
    }
}

// shared JSON decoder
extension DWSEndpoint {
    
    static let decoder = JSONDecoder()
    func decode<T:Decodable>(withJSON data: Data, decodingType: T.Type) -> DecodeResult<T> {
        do {
            let list = try DWSEndpoint.decoder.decode(T.self, from: data)
            return .success(list)
        } catch {
            return .error(error)
        }
    }
}

// endpoint-specific properties
extension DWSEndpoint {

    // constants
    var scheme: String { return "http" }
    var host: String { return "www.dreamwaresys.com" }
    var apiCode: URLQueryItem { return URLQueryItem(name: "code", value: "J23RVFJR") }
    
    // endpoint path generation
    var path: String {
        switch self {
        case .search(_):
            return "/api/address/get/autocomp.php"
        case .details(_):
            return "/api/address/get/details.php"
        }
    }
    
    // endpoint parameters
    var params: [URLQueryItem] {
        switch self {
        case .search(let text):
            return [URLQueryItem(name: "str", value: text)]
        case .details(let placeid):
            return [URLQueryItem(name: "placeid", value: String(placeid))]
        }
    }
}
