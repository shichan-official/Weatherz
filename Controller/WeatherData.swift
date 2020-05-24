//
//  WeatherData.swift
//  Weatherz
//
//  Created by Siavash Jalali on 2020/05/24.
//  Copyright © 2020 Siavash Jalali. All rights reserved.
//

import Foundation

struct WeatherData : Decodable {
    let name: String
    let main: WeatherSummary
    let weather: [Weather]
}

struct WeatherSummary : Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity : Int
}

struct Weather : Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
