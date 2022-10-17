//
//  LocationManager.swift
//  WeatherApp
//
//  Created by 문철현 on 2022/10/13.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func locationManagerDidUpdate(currentLocation: Location)
    func cityNameDidUpdate(cityName: String)
}

class LocationManager: NSObject {
    weak var delegate: LocationManagerDelegate?
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.requestAlwaysAuthorization()  // 위치 정보 접근 권한 요청
    }
    
    func requestCurrentLocation() {
        if(manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways){
            self.updateCurrentLocation()
        }
    }
    
    private func updateCurrentLocation() {
        manager.requestLocation()
        if let location = manager.location {
            let currentLocation = Location(coordinate: Coordinate(coordinate: location.coordinate), name: self.getCityName(currentLocation: location))

            self.delegate?.locationManagerDidUpdate(currentLocation: currentLocation)
        }
    }
    
    private func getCityName(currentLocation location: CLLocation) -> String {
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        var cityName: String = ""
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, _ in
            guard let placemarks = placemarks else { return }
            guard let address = placemarks.first else { return }
            
            cityName = address.locality?.description ?? "error"
            self.delegate?.cityNameDidUpdate(cityName: cityName)
        }
        return cityName
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == .authorizedWhenInUse || status == .authorizedAlways){
            self.updateCurrentLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let currentLocation = Location(coordinate: Coordinate(coordinate: location.coordinate), name: self.getCityName(currentLocation: location))
            // let cityName = self.getCityName(currentLocation: location)
            self.delegate?.locationManagerDidUpdate(currentLocation: currentLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: did fail to get current location")
    }
}


