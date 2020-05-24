//
//  WeatherApi.swift
//  Weatherz
//
//  Created by Siavash Jalali on 2020/05/24.
//  Copyright © 2020 Siavash Jalali. All rights reserved.
//

import Foundation

protocol WeatherApiDelegate {
    func didUpdateWeather(weather: WeatherModel)
}

struct WeatherApi {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=3322576cb29d590664fba17b7734a32d&q="
    
    var delegate: WeatherApiDelegate?
    
    func fetchWeather(city: String) {
        let url = weatherUrl + city
        requestWeather(url: url)
    }
    
    func requestWeather(url: String) {
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let weatherData = data {
                    if let weather = self.parseJSON(weatherData: weatherData) {
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedWeatherData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedWeatherData.weather[0].id
            let temprature = decodedWeatherData.main.temp
            let city = decodedWeatherData.name
            return WeatherModel(conditionId: id, cityName: city, temperature: temprature)
        } catch {
            print(error)
            return nil
        }
    }
}
