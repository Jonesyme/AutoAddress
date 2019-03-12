//
//  PlaceDetail.swift
//  AutoAddress
//
//  Created by Mike Jones on 3/12/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import Foundation

// codable places API response
struct PlaceDetailResponse: Codable {
    var status: String
    var error: String?
    var data: PlaceDetail
}

// place detail object
struct PlaceDetail: Codable {
    var lat: Double
    var lng: Double
    var ne_lat: Double
    var ne_lng: Double
    var sw_lat: Double
    var sw_lng: Double
}
