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
import CoreLocation


enum LocationBar: Int {
    case From = 1
    case To = 2
}

// MARK: - MainVC

class MainVC: UIViewController {
    
    // MARK: nib outlets
    @IBOutlet weak var searchOverlayView: UIView!
    @IBOutlet weak var searchBarFrom: UISearchBar!
    @IBOutlet weak var searchBarTo: UISearchBar!
    @IBOutlet weak var mapView: GMSMapView!
    
    // MARK: member variables
    var placeList = [PlaceDetail]()
    var selectedBar = LocationBar.From
    var locationManager = CLLocationManager()
    
    // MARK: view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBarFrom.tag = LocationBar.From.rawValue
        searchBarFrom.delegate = self
        searchBarTo.tag = LocationBar.To.rawValue
        searchBarTo.delegate = self
        
        // configure map viewport
        mapView.camera = GMSCameraPosition.camera(withLatitude: 37.78, longitude: -122.40, zoom: 12.0)
        mapView.isMyLocationEnabled = true
        
        // fetch current location
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchBarFrom.textColor = .black
        searchBarTo.textColor = .black
    }
}

// MARK: - Google Maps Helpers

extension MainVC: CLLocationManagerDelegate {
    
    // auto-size viewport to display all markers
    func autoSizeMapViewport() {
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
    
    // location delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lat = locations.last?.coordinate.latitude ?? 37.785834
        let lng = locations.last?.coordinate.longitude ?? -122.406417
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 17.0)
        self.mapView.animate(to: camera)
        self.locationManager.stopUpdatingLocation() // cease updating location
    }
}

// MARK: - UISearchBarDelegate

extension MainVC: UISearchBarDelegate {

    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        selectedBar = LocationBar(rawValue: searchBar.tag) ?? LocationBar.From

        let storyboard = UIStoryboard(name:"Main", bundle:nil)
        guard let searchVC = storyboard.instantiateViewController(withIdentifier: SearchVC.storyboardID) as? SearchVC else {
            return false
        }
        searchVC.delegate = self
        navigationController?.pushViewController(searchVC, animated: true)
        return false // don't become first responder
    }
}

// MARK: - SearchPlacesDelegate

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
            self.autoSizeMapViewport()
        })
    }
}
