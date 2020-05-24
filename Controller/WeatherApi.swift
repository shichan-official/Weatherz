//
//  WeatherApi.swift
//  Weatherz
//
//  Created by Siavash Jalali on 2020/05/24.
//  Copyright © 2020 Siavash Jalali. All rights reserved.
//

import Foundation

protocol WeatherApiDelegate {
    func didUpdateWeather(_ weatherApi: WeatherApi, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherApi {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=3322576cb29d590664fba17b7734a32d"
    
    var delegate: WeatherApiDelegate?
    
    func fetchWeather(city: String) {
        let url = weatherUrl + "&q=" + city
        requestWeather(url)
    }
    
    func fetchWeather(lat: String, lon: String) {
        let url = weatherUrl + "&lat=" + lat + "&lon=" + lon
        requestWeather(url)
    }
    
    func requestWeather(_ url: String) {
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let weatherData = data {
                    if let weather = self.parseJSON(weatherData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedWeatherData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedWeatherData.weather[0].id
            let description = decodedWeatherData.weather[0].description
            let temprature = decodedWeatherData.main.temp
            let city = decodedWeatherData.name
            return WeatherModel(conditionId: id, description: description, cityName: city, temperature: temprature)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
