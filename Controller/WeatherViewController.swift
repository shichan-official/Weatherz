//
//  ViewController.swift
//  Weatherz
//
//  Created by Siavash Jalali on 2020/05/21.
//  Copyright © 2020 Siavash Jalali. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var tempratureUnit: UILabel!
    @IBOutlet weak var tempratureUnitDegree: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    
    var weatherApi = WeatherApi()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherApi.delegate = self
        searchField.delegate = self
        locationManager.delegate = self
        
        conditionImage.isHidden = true
        tempratureUnit.isHidden = true
        tempratureUnitDegree.isHidden = true
        weatherDescription.isHidden = true
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
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
            self.conditionImage.isHidden = false
            self.tempratureUnit.isHidden = false
            self.tempratureUnitDegree.isHidden = false
            self.weatherDescription.isHidden = false
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.formattedTemprature
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.weatherDescription.text = weather.description
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastestLocation = locations.last {
            locationManager.stopUpdatingLocation()
            let latitude = lastestLocation.coordinate.latitude
            let longitude = lastestLocation.coordinate.longitude
            weatherApi.fetchWeather(lat: String(latitude), lon: String(longitude))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
        loadingIndicator.startAnimating()
        locationManager.requestLocation()
    }
}
