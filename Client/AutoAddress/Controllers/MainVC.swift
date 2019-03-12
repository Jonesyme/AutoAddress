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
    
    @IBOutlet var searchBarFrom: UISearchBar!
    @IBOutlet var searchBarTo: UISearchBar!
    @IBOutlet var mapBox: UIImageView!
    
    var selectedBar = LocationBar.From
    var mapView: GMSMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBarFrom.tag = LocationBar.From.rawValue
        searchBarFrom.delegate = self
        searchBarFrom.barStyle = .black
        
        searchBarTo.tag = LocationBar.To.rawValue
        searchBarTo.delegate = self
        searchBarTo.barStyle = .black
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: mapBox.frame, camera: camera)
        mapView?.isMyLocationEnabled = true
        mapView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView!)
        
        if let mapView = mapView {
            NSLayoutConstraint.activate([
                mapView.leftAnchor.constraint(equalTo: mapBox.leftAnchor),
                mapView.topAnchor.constraint(equalTo: mapBox.topAnchor),
                mapView.rightAnchor.constraint(equalTo: mapBox.rightAnchor),
                mapView.bottomAnchor.constraint(equalTo: mapBox.bottomAnchor)
            ])
        }
 
       /* let place = GMSPlace()
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.map = mapView!
        
        */
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView!
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        
        PlacesWS().fetchPlaceDetails(placeID: place.place_id, completion:{ (detail, error) in
            guard let placeDetail = detail else {
                return
            }
            // add marker to map
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: placeDetail.lat, longitude: placeDetail.lng)
            marker.title = place.desc
            marker.snippet = "Start"
            marker.map = self.mapView!
            
            
            // re-focus map
            var bounds = GMSCoordinateBounds()
            bounds = bounds.includingCoordinate(marker.position)
            let update = GMSCameraUpdate.fit(bounds, withPadding: 60000)
            self.mapView!.animate(with: update)
            
        })

        
    }
}
