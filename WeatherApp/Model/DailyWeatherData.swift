//
//  DailyWeatherData.swift
//  WeatherApp
//
//  Created by 문철현 on 2022/10/24.
//

import UIKit

class DailyWeatherData {
    var icon: UIImage
    
    private var dateText: String
    private let tempMin: Double
    private let tempMax: Double
    
    var dateTextMMDD: String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd"  // 2022-10-23 09:00:00
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let convertDate = dateFormatter.date(from: self.dateText)
        
        let toDateFormatter = DateFormatter()
        toDateFormatter.dateFormat = "MM월 dd일"
        toDateFormatter.locale = Locale(identifier: "ko_KR")
        
        return toDateFormatter.string(from: convertDate!)
    }
    
    var minMaxTemp: String {
        return String(Int(self.tempMin)) + "° ~ " + String(Int(self.tempMax)) + "°"
    }
    
    init(iconName: String, dateText: String, tempMin: Double, tempMax: Double) {
        self.dateText = dateText
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.icon = UIImage(named: iconName) ?? UIImage()
    }
    
}
