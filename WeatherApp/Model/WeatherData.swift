//
//  WeatherData.swift
//  WeatherApp
//
//  Created by 문철현 on 2022/10/13.
//

import Foundation

struct WeatherData: Codable {
    let timezone: Int?
    let id: Int?
    let name: String?
    let cod: Int?
    
    let coord: Coord?
    let weather: [Weather]?
    let main: Main?
}

struct Coord: Codable {
    let lon: Double?
    let lat: Double?
}

struct Weather: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

struct Main: Codable {
    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int?
    let humidity: Int?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }
    
    func getTempString() -> String {
        return String(Int(self.temp ?? 0)) + "°"
    }
}


