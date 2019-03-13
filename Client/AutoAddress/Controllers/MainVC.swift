//
//  MainVC.swift
//  AutoAddress
//
//  Created by Mike Jones on 2/25/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import UIKit
import Foundation
import GoogleMaps

enum LocationBar: Int {
    case From = 1
    case To = 2
}

class MainVC: UIViewController {
    
    @IBOutlet weak var searchOverlayView: UIView!
    @IBOutlet weak var searchBarFrom: UISearchBar!
    @IBOutlet weak var searchBarTo: UISearchBar!
    @IBOutlet weak var mapView: GMSMapView!
    
    var placeList = [PlaceDetail]()
    var selectedBar = LocationBar.From

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBarFrom.tag = LocationBar.From.rawValue
        searchBarFrom.delegate = self
        searchBarFrom.barStyle = .black
        
        searchBarTo.tag = LocationBar.To.rawValue
        searchBarTo.delegate = self
        searchBarTo.barStyle = .black
        
        // configure map's camera or viewport
        mapView.camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView.isMyLocationEnabled = true

        /*
            // creates a marker in the center of the map.
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
            marker.title = "Sydney"
            marker.snippet = "Australia"
            marker.map = mapView
        */
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // auto-zoom around all map markers
    func autoZoomMap() {
        var bounds = GMSCoordinateBounds()
        for placeDetail in placeList {
            // TODO: shouldn't we be storing/looping over the markers instead ??
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude:placeDetail.lat, longitude:placeDetail.lng)
            marker.map = self.mapView
            bounds = bounds.includingCoordinate(marker.position)
        }
        
        mapView.setMinZoom(1, maxZoom: 15) // hack to prevent over zoom and prep for animation
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50))
        mapView.setMinZoom(1, maxZoom: 20) // hack to re-enable user's zoom controls
        
    }
}

extension MainVC: UISearchBarDelegate {

    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        selectedBar = LocationBar(rawValue: searchBar.tag) ?? LocationBar.From

        let storyboard = UIStoryboard(name:"Main", bundle:nil)
        guard let searchVC = storyboard.instantiateViewController(withIdentifier:"searchVC") as? SearchVC else {
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
        
        PlacesWS().fetchPlaceDetails(placeID: place.place_id, completion:{ (detail, error) in
            guard let placeDetail = detail else {
                return
            }
            
            // add marker to map
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: placeDetail.lat, longitude: placeDetail.lng)
            marker.title = place.desc
            marker.snippet = "Start"
            marker.map = self.mapView
            
            // TODO: this will never remove markers!
            self.placeList.append(placeDetail)
            self.autoZoomMap()
        })
    }
}
