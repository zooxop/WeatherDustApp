//
//  ServiceError.swift
//  WeatherApp
//
//  Created by 문철현 on 2022/10/13.
//

import Foundation

enum ServiceError: Error {
    case urlError
    case networkRequestError
    case impossibleToGetJSONData
    case impossibleToParseJSON
}
