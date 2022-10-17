//
//  Location.swift
//  WeatherApp
//
//  Created by 문철현 on 2022/10/13.
//

import Foundation

struct Location: Codable {
    let coordinate: Coordinate
    var name: String?  // 도시 이름
    
    init(coordinate: Coordinate, name: String? = nil) {
        self.coordinate = coordinate
        self.name = name
    }
}
