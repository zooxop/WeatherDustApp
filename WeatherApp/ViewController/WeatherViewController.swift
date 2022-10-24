//
//  ViewController.swift
//  WeatherApp
//
//  Created by 문철현 on 2022/10/13.
//
// ViewModel <-> Observable 객체와 데이터 주고받는 방식(순서) 제대로 분석하기

// 1. view 나누기
// 2. table view -> collection view로 바꾸기

import UIKit
import CoreLocation

extension WeatherViewController: LocationManagerDelegate {
    func locationManagerDidUpdate(currentLocation: Location) {
        self.location = currentLocation  // 현재 위치 정보 가져오기
    }
    
    // 현재 위치에 대해 geocoder를 통해, 한글로 된 도시명 가져오기.
    func cityNameDidUpdate(cityName: String) {
        DispatchQueue.main.async {
            self.cityNameLabel.text = cityName
        }
    }
}

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    private var locationManager = LocationManager()
    
    // 위치 정보
    var location : Location!
    
    var viewModel: WeatherViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            // location에 대한 observe는 당장 쓸 일이 없어서 주석처리함.
//            viewModel.location.observe { [unowned self] in
//                if let cityName = $0.name {
//                    // self.cityNameLabel.text = cityName
//                }
//            }
            viewModel.weather.observe { [unowned self] in
                if let description = $0.description {
                    self.statusLabel.text = description
                }
                if let icon = $0.icon {
                    // icon 이름으로 assets에서 이미지 가져오기
                    self.statusImageView.image = UIImage(named: icon.iconName) ?? UIImage()
                }
                
            }
            viewModel.main.observe { [unowned self] in
                guard $0.temp != nil else { return }
                self.temperatureLabel.text = $0.getTempString()
            }
            viewModel.hourlyData.observe { [unowned self] _ in
                self.hourlyCollectionView.reloadData()
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.requestCurrentLocation()
        
        self.hourlyCollectionView.delegate = self
        self.hourlyCollectionView.dataSource = self
        self.hourlyCollectionView.register(UINib(nibName: "ForecastCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ForecastCollectionViewCell")
        
        self.getForecastData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.hourlyCollectionView.layer.addBorder([.bottom], color: UIColor.black, width: 1.0)
    }
    
    private func getForecastData() {
        guard let location = self.location else {
            print(LocationError.noLocationConfigured.localizedDescription)
            return
        }
        self.viewModel = WeatherViewModel(location: location)
        self.viewModel?.retrieveForecastData()
    }
    
    private func getCurrentWeatherData() {
        guard let location = self.location else {
            print(LocationError.noLocationConfigured.localizedDescription)
            return
        }
        self.viewModel = WeatherViewModel(location: location)
        self.viewModel?.retrieveWeatherData()
        print(location.coordinate)
    }

    
}


extension WeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel?.hourlyData.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCollectionViewCell", for: indexPath) as! ForecastCollectionViewCell
        
        guard let tempInfo = self.viewModel?.hourlyData.value?[indexPath.row] else {
            return ForecastCollectionViewCell()
        }
        
        cell.timeLabel.text = tempInfo.dtTxt?.hourlyTime
        cell.tempLabel.text = tempInfo.main?.getTempString()
        
        if let icon = tempInfo.weather?.first?.icon?.iconName {
            cell.weatherImageView.image = UIImage(named: icon) ?? UIImage()
        }
        
        return cell
    }
    
    
}
