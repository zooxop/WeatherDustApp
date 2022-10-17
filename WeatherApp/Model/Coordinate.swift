//
//  Coordinate.swift
//  WeatherApp
//
//  Created by 문철현 on 2022/10/13.
//

import Foundation
import CoreLocation

class Coordinate: Codable {
    let latitude: String
    let longitude: String
    
    init(location: CLLocation) {
        self.latitude = String(location.coordinate.latitude)
        self.longitude = String(location.coordinate.longitude)
    }
    
    init(coordinate: CLLocationCoordinate2D) {
        self.latitude = String(coordinate.latitude)
        self.longitude =  String(coordinate.longitude)
    }
    
    init(lat: String, lon: String) {
        self.latitude = lat
        self.longitude = lon
    }
}

extension Coordinate: CustomStringConvertible {
    var description: String {
        return "lat: \(self.latitude), lon: \(self.longitude)"
    }
}
