//
//  PlacesWS.swift
//  AutoAddress
//
//  Created by Mike Jones on 3/7/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import Foundation
import UIKit

// webservice errors
enum WebServiceError : Error {
    case Connection
    case Parsing
    case BadResponse
    case Unknown
    var description: String {
        switch self {
        case .Connection:
            return "Unable to connect"
        case .Parsing:
            return "Failed to parse response"
        case .BadResponse:
            return "Bad API response"
        case .Unknown:
            return "Unknown error"
        }
    }
}

// generic web service
protocol RemoteWebService {
    associatedtype X
    func asyncRecordSearch(searchText:String, completion:@escaping(_ response:[X]?, _ error:WebServiceError?) -> Void)
}

// custom DWS places web service
class PlacesWS: RemoteWebService {
    
    let session:URLSession = URLSession.shared
    let dwsCode:String = "J23RVFJR"
    let baseURL:String = "http://www.dreamwaresys.com/api/address/"
    
    // async fetch API response
    func asyncRecordSearch(searchText: String, completion: @escaping(_ response: [Place]?, _ error: WebServiceError?) -> Void) {
        
        let urlstring = baseURL + "get_autocomp.php?code=" + dwsCode + "&str=" + searchText
        guard let url = URL(string: urlstring) else {
            completion(nil, WebServiceError.Unknown)
            return
        }
        
        let task = self.session.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    // network error
                    completion(nil, WebServiceError.Connection)
                    print("WebServiceError: " + error.localizedDescription)
                }
                return
            }
            guard let response = response as? HTTPURLResponse, let data = data, response.statusCode == 200, response.mimeType == "application/json" else {
                DispatchQueue.main.async {
                    // bad response error
                    completion(nil, WebServiceError.BadResponse)
                }
                return
            }

            do {
                let responseObj = try JSONDecoder().decode(PlaceResponse.self, from:data)
                if let apiError = responseObj.error {
                    if !apiError.isEmpty {
                        DispatchQueue.main.async {
                            // response contained an API-specific error
                            completion(nil, WebServiceError.BadResponse)
                            print("API Response Error: " + apiError)
                        }
                    }
                }
                let list = responseObj.list
                DispatchQueue.main.async {
                    // success!
                    completion(list, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    // JSON parsing failure
                    completion(nil, WebServiceError.Parsing)
                }
            }
        })
        task.resume()
    }
    
}
