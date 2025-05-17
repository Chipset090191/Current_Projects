//
//  CurrentWeatherData.swift
//  Sunny
//
//  Created by Михаил Тихомиров on 13.03.2024.
//  Copyright © 2024 Ivan Akulov. All rights reserved.
//

import Foundation


struct CurrentWeatherData: Codable {
    let name:String
    let main:Main
    let weather:[Weather]
}

struct Main: Codable{
    let temp: Double
    let feelsLike: Double
    
    // we change the key name by using CodingKeys enum
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"   // we say that we get feels like by using field feels_like - original but change that to feelsLike in our code further
    }
}


struct Weather: Codable {
    let id:Int
}
