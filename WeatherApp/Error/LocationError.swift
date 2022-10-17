//
//  LocationError.swift
//  WeatherApp
//
//  Created by 문철현 on 2022/10/13.
//

import Foundation

enum LocationError: Error {
    case locationManagerRequestFail
    case noLocationConfigured
    case localSearchRequstFail
    case localSearchCompleterFail
    
    var localizedDescription: String {
        switch self {
        case .locationManagerRequestFail:
            return "Location Error: Fail to get current location"
        case .noLocationConfigured:
            return "Location Error: WeatherViewController has no location"
        case .localSearchRequstFail:
            return "Local Search Request Error : No corresoponding location data for user selection"
        case .localSearchCompleterFail:
            return "Local search completer is unable to generate a list of search results"
        }
    }
    
}
