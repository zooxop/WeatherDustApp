//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by 문철현 on 2022/10/13.
//

import Foundation

class WeatherViewModel {
    let maxItemCount = 20
    let weatherApiManager = WeatherAPIManager()
    var location: Observable<Location>
    var weather: Observable<Weather>
    var main: Observable<Main>
    
    init(location: Location) {
        self.location = Observable(location)
        self.weather = Observable(nil)
        self.main = Observable(nil)
    }
    
    func retrieveWeatherData() {
        guard let location = location.value else {
            return
        }
        
        weatherApiManager.requestWeatherData(location: location) { weather, error in
            guard let weatherData = weather, error == nil else {
                print(error ?? "")
                return
            }
            DispatchQueue.main.async {
                self.update(weatherData: weatherData)
            }
        }
        
    }
    
    // 옵저버에게 전달할 내용을 작성한다.
    func update(weatherData: WeatherData) {
        self.weather.value = weatherData.weather?.first
        self.main.value = weatherData.main
    }
    
}
