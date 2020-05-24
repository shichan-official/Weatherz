//
//  ViewController.swift
//  Weatherz
//
//  Created by Siavash Jalali on 2020/05/21.
//  Copyright © 2020 Siavash Jalali. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UISearchTextFieldDelegate {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    
    var weatherApi = WeatherApi()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchField.delegate = self
    }

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
        let city = searchField.text ?? ""
        weatherApi.fetchWeather(city: city)
        searchField.text = ""
    }
}

