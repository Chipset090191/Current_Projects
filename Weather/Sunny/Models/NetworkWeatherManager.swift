//
//  NetworkWeatherManager.swift
//  Sunny
//
//  Created by Михаил Тихомиров on 13.03.2024.
//

import Foundation
import CoreLocation

class NetworkWeatherManager {
    
    enum RequestType {
        case cityName(city: String)
        case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    var onCompletion: ((CurrentWeather) ->Void)?
    
    func fetchCurrentWeather(forRequestType requestType: RequestType) {
        var urlString = ""
        switch requestType {
        case .cityName(let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apikey)&units=metric"
        case .coordinate(let latitude, let longitude):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apikey)&units=metric"
        }
        performRequest(withURLString: urlString)
    }
    
    
//    func fetchCurrentWeather(forCity city:String) {
//        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apikey)&units=metric"
//        performRequest(withURLString: urlString)
//    }
//    
//    
//    func fetchCurrentWeather(forLatitude latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
//        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apikey)&units=metric"
//        performRequest(withURLString: urlString)
//    }
    
    
    
    // this fileprivate because we do not use it anywhere just only in our class
    fileprivate func performRequest(withURLString urlString: String) {
        guard let url = URL(string: urlString) else { return }
           let session = URLSession(configuration: .default)
        let _: Void = session.dataTask(with: url) { data, response, error in
               guard let data = data else {
                   print ("There is no data!")
                   return
               }
            if let currentWeather = self.parseJSON(withData: data) {
                self.onCompletion?(currentWeather)
            }
        
           }.resume()
    }
    
    
    
    fileprivate func parseJSON(withData data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        if let currentWeatherData = try? decoder.decode(CurrentWeatherData.self, from: data) {
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else {
                return nil
            }
            return currentWeather
        }
        return nil
    }
}
