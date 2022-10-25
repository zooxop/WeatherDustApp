//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by 문철현 on 2022/10/13.
//

import Foundation

class WeatherViewModel {
    let maxHourlyItemCnt = 25
    let weatherApiManager = WeatherAPIManager()
    var location: Observable<Location>
    var weather: Observable<Weather>
    var main: Observable<Main>
    var hourlyData: Observable<[List]>
    var dailyData: Observable<[DailyWeatherData]>
    
    init(location: Location) {
        self.location = Observable(location)
        self.weather = Observable(nil)
        self.main = Observable(nil)
        self.hourlyData = Observable([])
        self.dailyData = Observable([])
    }
    
    private func getWeekText(_ dateText: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"  // 2022-10-23 09:00:00
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let convertDate = dateFormatter.date(from: dateText)
        
        let toDateFormatter = DateFormatter()
        toDateFormatter.dateFormat = "MM-dd"
        toDateFormatter.locale = Locale(identifier: "ko_KR")
        
        return toDateFormatter.string(from: convertDate!)
    }
    
    private func getDailyForecastData() -> [DailyWeatherData]? {
        // 딕셔너리 key로 날짜(또는 요일) 추려서 할당해주기.
        // 모든 데이터의 min/max 온도를 날짜별 딕셔너리에 대입하기
        // iconName 기준 내림차순 정렬하여, 대표 아이콘 찾기.
        if let forecastDatas = self.hourlyData.value {
            var tempMin = [String: Double]()
            var tempMax = [String: Double]()
            var repIcon = [String: String]()
            
            var dailyWeatherDatas = [DailyWeatherData]()
            
            for data in forecastDatas {
                let weekText = self.getWeekText(data.dtTxt!)
                tempMin.merge([weekText: data.main!.tempMin!]) { return $0 > $1 ? $1 : $0 }
                tempMax.merge([weekText: data.main!.tempMax!]) { return $0 > $1 ? $0 : $1 }
                
                repIcon.merge([weekText: data.weather!.first!.icon!]) {
                    let idx = $0.index($0.startIndex, offsetBy: 2)
//                            return String(self[self.startIndex ..< idx])
                    return $0 > $1 ? $0[$0.startIndex ..< idx] + "d" : $1[$1.startIndex ..< idx] + "d"
                }
            }
            
            for key in tempMax.keys.sorted() {
                let dailyWeatherData = DailyWeatherData(iconName: repIcon[key]!, dateText: key, tempMin: tempMin[key]!, tempMax: tempMax[key]!)
                dailyWeatherDatas.append(dailyWeatherData)
            }
            
            return dailyWeatherDatas
        } else {
            return nil
        }
        
    }
    
    func retrieveForecastData() {
        guard let location = self.location.value else { return }
        
        weatherApiManager.requestForecastData(location: location) { forecast, error in
            guard let forecastData = forecast, error == nil else {
                print(error ?? "")
                return
            }
            DispatchQueue.main.async {
                self.update(forecastData: forecastData)
            }
        }
    }
    
    func retrieveWeatherData() {
        guard let location = self.location.value else { return }
        
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
    
    func update(forecastData: ForecastData) {
        guard let currentWeather = forecastData.list?.first else { return }
        self.weather.value = currentWeather.weather?.first
        self.main.value = currentWeather.main
        self.hourlyData.value = forecastData.list
        self.dailyData.value = self.getDailyForecastData()
    }
    
}
