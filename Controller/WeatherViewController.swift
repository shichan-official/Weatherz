//
//  ViewController.swift
//  Weatherz
//
//  Created by Siavash Jalali on 2020/05/21.
//  Copyright © 2020 Siavash Jalali. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var weatherApi = WeatherApi()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.stopAnimating()
        weatherApi.delegate = self
        searchField.delegate = self
    }
}

//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchField.text != "" {
            return true
        } else {
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        loadingIndicator.startAnimating()
        let city = searchField.text ?? ""
        weatherApi.fetchWeather(city: city)
        searchField.text = ""
    }
}

//MARK: - WeatherApiDelegate
extension WeatherViewController: WeatherApiDelegate {
    func didUpdateWeather(_ weatherApi: WeatherApi, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.formattedTemprature
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
