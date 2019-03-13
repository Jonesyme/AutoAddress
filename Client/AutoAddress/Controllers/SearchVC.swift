//
//  SearchVC.swift
//  AutoAddress
//
//  Created by Mike Jones on 3/7/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import UIKit

// MARK: - SearchModalDelegate
//          delegate to communicate user's address selection back to the parent viewcontroller
protocol SearchModalDelegate: AnyObject {
    func didSelectPlace(_ place: Place)
}

//
// MARK: - Search View Controller
//          Functions like a modal view that is shared between the start/destination address boxes
class SearchVC: UITableViewController {
    
    // MARK: class methods
    class var storyboardID: String {
        return "searchVC"
    }
    
    // MARK: member variables
    var searchResults = [Place]()
    var searchManager = SearchManager()
    var searchCtrlr = UISearchController(searchResultsController: nil)
    
    weak var delegate: SearchModalDelegate?
    
    // MARK: view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchManager.delegate = self
        
        searchCtrlr.searchResultsUpdater = self
        searchCtrlr.obscuresBackgroundDuringPresentation = false
        searchCtrlr.searchBar.placeholder = "Enter a location"
        searchCtrlr.searchBar.sizeToFit()
        
        navigationItem.hidesBackButton = true
        navigationItem.searchController = searchCtrlr
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        searchCtrlr.searchBar.textColor = .white
        searchCtrlr.searchBar.tintColor = .darkGray
        searchCtrlr.searchBar.barStyle = UIBarStyle.blackTranslucent
        
        searchCtrlr.isActive = true
        searchCtrlr.searchBar.delegate = self
        searchCtrlr.searchBar.becomeFirstResponder()
        
        super.viewDidAppear(animated)
    }
    
}

// MARK: - SearchManagerDelegate

extension SearchVC: SearchManagerDelegate {
    
    func newSearchResultsAvailable(results: [Place]) {
        self.searchResults = results
        self.tableView.reloadData()
    }
    
    func networkErrorOccured(desc: String) {
        print("Error: network unavailable")
    }
}

// MARK: - TableView Delegates

extension SearchVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:SearchCell.identifier, for: indexPath) as? SearchCell else {
            print("Error: unable to dequeue a SearchCell")
            return UITableViewCell()
        }
        
        let title = searchResults[indexPath.row].structured_main
        let detail = searchResults[indexPath.row].structured_second
        cell.configureCellForDisplay(titleText:title, detailText:detail)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let placeObj = searchResults[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: false)
        delegate?.didSelectPlace(placeObj)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension SearchVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
}
    
// MARK: - UISearchResultsUpdating

extension SearchVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text.count > 2 else {
            return
        }
        
        searchManager.searchTextDidChange(text)
    }
}

