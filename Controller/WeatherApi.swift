//
//  WeatherApi.swift
//  Weatherz
//
//  Created by Siavash Jalali on 2020/05/24.
//  Copyright © 2020 Siavash Jalali. All rights reserved.
//

import Foundation

struct WeatherApi {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=3322576cb29d590664fba17b7734a32d&q="
    
    func fetchWeather(city: String) {
        let url = weatherUrl + city
        requestWeather(url: url)
    }
    
    func requestWeather(url: String) {
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handleSessionTask(data:urlResponse:error:))
            task.resume()
        }
    }
    
    func handleSessionTask(data: Data?, urlResponse: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        
        if let weatherData = data {
            let weatherDataString = String(data: weatherData, encoding: .utf8)
            print(weatherDataString!)
        }
    }
}
