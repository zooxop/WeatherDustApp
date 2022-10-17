//
//  IconNameString.swift
//  WeatherApp
//
//  Created by 문철현 on 2022/10/17.
//

import Foundation

extension String {
    var iconName: String {
        let idx = self.index(self.startIndex, offsetBy: 2)
        return String(self[self.startIndex ..< idx])
    }
}
