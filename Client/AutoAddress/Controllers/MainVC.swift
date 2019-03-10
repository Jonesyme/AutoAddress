//
//  MainVC.swift
//  AutoAddress
//
//  Created by Mike Jones on 2/25/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import UIKit
import Foundation

enum LocationBar: Int {
    case From = 1
    case To = 2
}

class MainVC: UIViewController {
    
    @IBOutlet var searchBarFrom: UISearchBar!
    @IBOutlet var searchBarTo: UISearchBar!
    
    var selectedBar = LocationBar.From
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBarFrom.tag = LocationBar.From.rawValue
        searchBarFrom.delegate = self
        searchBarFrom.barStyle = .black
        
        searchBarTo.tag = LocationBar.To.rawValue
        searchBarTo.delegate = self
        searchBarTo.barStyle = .black
    }
}

extension MainVC: UISearchBarDelegate {

    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        selectedBar = LocationBar(rawValue: searchBar.tag) ?? LocationBar.From

        let storyboard = UIStoryboard(name:"Main", bundle:nil)
        guard let searchVC = storyboard.instantiateViewController(withIdentifier:"SearchVC") as? SearchVC else {
            return false
        }
        searchVC.delegate = self
        navigationController?.pushViewController(searchVC, animated: true)
        return false // don't become first responder
    }
}

extension MainVC: SearchPlacesDelegate {
    
    public func didSelectPlace(_ place:Place) {
        if selectedBar.rawValue == searchBarFrom.tag {
            searchBarFrom.text = place.desc
        } else {
            searchBarTo.text = place.desc
        }
    }
}
