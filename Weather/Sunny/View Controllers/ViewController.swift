//
//  ViewController.swift
//  Sunny
//
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    
    
    var networkWeatherManager = NetworkWeatherManager()
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    @IBAction func searchPressed(_ sender: UIButton) {   // sauing unowned self - we guarantee that self is existed after closure worked
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [unowned self] city in
            // this task works immediatelly bacause we are waiting our data now!
            DispatchQueue.global(qos: .userInteractive).async {
                self.networkWeatherManager.fetchCurrentWeather(forRequestType: .cityName(city: city))
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // This code must go first so that to prepare onCompletion then
        // we simply call fetchCurrentWeather anywhere and result will be put to onCompletion
        // That seems like we allocate memory for onCmpletion on networkWeatherManager class then we simply update it and then update our interface UI
        networkWeatherManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }  // we exctract self here
            self.updateInterfaceWith(weather: currentWeather)
        }
        
        _ = locationManager  // we trigger our lazy var variable
        
            
    }
    
    func updateInterfaceWith(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.feelsLikeTemperatureLabel.text = weather.feelsLikeTemperatureString
            self.weatherIconImageView.image = UIImage(systemName: weather.systemIconNameString)
        }
        
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    // 1
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
        }
    }
    
    // 2
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.networkWeatherManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}





