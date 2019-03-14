//
//  SearchManager.swift
//  AutoAddress
//
//  Created by Mike Jones on 3/13/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import Foundation


// MARK: - SearchManagerDelegate
//          grants subscriber real-time search results data
protocol SearchManagerDelegate: AnyObject {
    func newSearchResultsAvailable(results: [Place])
    func networkErrorOccured(desc: String)
}


// MARK: - Search Manager
//          Manage asynchronous network requests for auto-completion search feature in order
//          to avoid network request redundancy and generally simplify the VC's role
//
class SearchManager {
    
    internal var resultList = [Place]()
    internal var fetchInProgress: Bool
    internal var nextSearchText: String
    internal var currSearchText: String
    
    weak var delegate: SearchManagerDelegate?
    
    init() {
        fetchInProgress = false
        nextSearchText = ""
        currSearchText = ""
    }
    
    public func searchResults() -> [Place] {
        return self.resultList
    }
    
    public func searchTextDidChange(_ text:String) {
        nextSearchText = text
        if !self.fetchInProgress {
            executeNewFetch(text)
        }
    }
    
    private func executeNewFetch(_ text: String) {
        fetchInProgress = true
        currSearchText = text
        
        APIClient.shared().get(DWSEndpoint.search(text: text), responseType: PlaceResponse.self) { result in
            switch result {
            case .error(let error):
                self.delegate?.networkErrorOccured(desc: error.localizedDescription)
            case .result(let placeResponse):
                self.resultList = placeResponse.list
                self.delegate?.newSearchResultsAvailable(results: self.resultList)
            }
            self.fetchInProgress = false
        }
    }
    
}
