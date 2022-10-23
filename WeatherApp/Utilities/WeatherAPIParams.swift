//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by 문철현 on 2022/10/13.
//

import Foundation

class WeatherAPIParams {
    static let forecastURL = "https://api.openweathermap.org/data/2.5/forecast"
    static let currentWeatherURL = "https://api.openweathermap.org/data/2.5/weather"
    static let appID = "2c46d614284b48109216eab769049f3d"
    static let lang = "kr"
    static let units = "metric"  // 온도 단위를 섭씨로 받기. (기본: 화씨)
}
