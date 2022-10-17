//
//  APIManager.swift
//  WeatherApp
//
//  Created by 문철현 on 2022/10/15.
//

import Foundation

protocol APIManagable: AnyObject {
    // func requestData(with item: Any?, completion: @escaping (Data?, Error?) -> Void)
}

class WeatherAPIManager {
    typealias WeatherCompletion = (WeatherData?, Error?) -> Void
    
    public static let shared = WeatherAPIManager()
    weak var delegate: APIManagable?
    
    public func requestWeatherData(location: Location, completion: @escaping WeatherCompletion ) {
        guard let url = self.getCurrentWeatherURL(location: location) else {
            completion(nil, ServiceError.urlError)
            return
        }
        print(url.description)
        // API 호출
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(nil, ServiceError.networkRequestError)
                return
            }
            guard let data = data else {
                completion(nil, ServiceError.impossibleToGetJSONData)
                return
            }
            
            let decoder = JSONDecoder()
            guard let hasWeatherData = try? decoder.decode(WeatherData.self, from: data) else {
                completion(nil, ServiceError.impossibleToParseJSON)
                return
            }
            completion(hasWeatherData, nil)
            
        }.resume()
        
    }
    
    private func getCurrentWeatherURL(location: Location) -> URL? {
        var url = URLComponents(string: WeatherAPIParams.currentWeatherURL)
        
        let latitude = URLQueryItem(name: "lat", value: location.coordinate.latitude)
        let longitude = URLQueryItem(name: "lon", value: location.coordinate.longitude)
        let appId = URLQueryItem(name: "appid", value: WeatherAPIParams.appID)
        let lang = URLQueryItem(name: "lang", value: WeatherAPIParams.lang)
        let units = URLQueryItem(name: "units", value: WeatherAPIParams.units)
        
        url?.queryItems = [latitude, longitude, appId, lang, units]
        
        return url?.url
    }
    
}
