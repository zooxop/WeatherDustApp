//
//  IconNameString.swift
//  WeatherApp
//
//  Created by 문철현 on 2022/10/17.
//

import Foundation

extension String {
    
    var hourlyTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"  // 2022-10-23 09:00:00
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let convertDate = dateFormatter.date(from: self)
        
        let toDateFormatter = DateFormatter()
        toDateFormatter.dateFormat = "a HH시"
        toDateFormatter.locale = Locale(identifier: "ko_KR")
        
        return toDateFormatter.string(from: convertDate!)
    }
}
