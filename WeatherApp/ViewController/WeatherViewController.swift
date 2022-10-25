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
    @IBOutlet weak var dailyCollectionView: UICollectionView!
    
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
                    self.statusImageView.image = UIImage(named: icon) ?? UIImage()
                }
                
            }
            viewModel.main.observe { [unowned self] in
                guard $0.temp != nil else { return }
                self.temperatureLabel.text = $0.getTempString()
            }
            viewModel.hourlyData.observe { [unowned self] _ in
                self.hourlyCollectionView.reloadData()
            }
            viewModel.dailyData.observe { [unowned self] _ in
                self.dailyCollectionView.reloadData()
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
        
        self.dailyCollectionView.delegate = self
        self.dailyCollectionView.dataSource = self
        self.dailyCollectionView.register(UINib(nibName: "DailyCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "DailyCollectionViewCell")
        
        self.getForecastData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // self.hourlyCollectionView.layer.addBorder([.bottom], color: UIColor.black, width: 1.0)
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
        if collectionView == hourlyCollectionView {
            if viewModel?.hourlyData.value?.count ?? 0 > 0 {
                return viewModel?.maxHourlyItemCnt ?? 0
            } else {
                return 0
            }
        } else if collectionView == dailyCollectionView {
            return viewModel?.dailyData.value?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == hourlyCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCollectionViewCell", for: indexPath) as! ForecastCollectionViewCell
            
            guard let tempInfo = self.viewModel?.hourlyData.value?[indexPath.row] else {
                return ForecastCollectionViewCell()
            }
            
            cell.timeLabel.text = tempInfo.dtTxt?.hourlyTime
            cell.tempLabel.text = tempInfo.main?.getTempString()
            
            if let icon = tempInfo.weather?.first?.icon {
                cell.weatherImageView.image = UIImage(named: icon) ?? UIImage()
            }
        
            return cell
            
        } else if collectionView == dailyCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyCollectionViewCell", for: indexPath) as! DailyCollectionViewCell
            
            if let data = self.viewModel?.dailyData.value?[indexPath.row] {
                cell.dateLabel.text = data.dateTextMMDD
                cell.minMaxTempLabel.text = data.minMaxTemp
                cell.repIconImageView.image = data.icon
                return cell
            } else {
                return DailyCollectionViewCell()
            }
        }
        
        return ForecastCollectionViewCell()
    }
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.dailyCollectionView {
            return CGSize(width: self.view.bounds.width - 10, height: 30)
        } else {
            let cgSize = collectionView.cellForItem(at: indexPath)?.bounds.size
            return cgSize ?? CGSize(width: 67.0, height: 104.0)
        }
        
    }
}
