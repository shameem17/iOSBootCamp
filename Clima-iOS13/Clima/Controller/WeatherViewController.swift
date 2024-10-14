//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchCity: UITextField!
    
    var weatherManager: WeatherManager = WeatherManager()
    var locationManager: CLLocationManager = CLLocationManager()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        weatherManager.delegate = self
        searchCity.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    
    @IBAction func searchLoaction(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    
}

// MARK: - TextField Delegate
extension WeatherViewController: UITextFieldDelegate{
    @IBAction func searchWeather(_ sender: UIButton) {
        print("search city=\(searchCity.text ?? "no city")")
        searchCity.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchCity.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }else{
            textField.placeholder = "Please Enter a valid city"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchCity.text{
            self.weatherManager.fetchWeatherByCity(cityName: city)
        }
        searchCity.text = ""
    }
}


// MARK: - WeatherManager Delegate
extension WeatherViewController: WeatherManagerDelegate{
    func updateUIData(withData weatherData: Weather) {
        DispatchQueue.main.async{[weak self] in
            self?.cityLabel.text = weatherData.name
            self?.temperatureLabel.text = "\(weatherData.main.temp)"
            self?.conditionImageView.image = UIImage(systemName: (self?.getWeatherIcon(code: weatherData.weather[0].id))!)
        }
    }
    
    func showError(error: any Error) {
        print("error=\(error)")
    }
    
    private func getWeatherIcon(code: Int) -> String{
        switch code{
        case 200..<300:
            return "cloud.bolt.fill"
        case 300..<400:
            return "cloud.drizzle.fill"
        case 500..<600:
            return "cloud.rain"
        case 600..<700:
            return "cloud.snow"
        case 700..<800:
            return "cloud.moon"
        case 800:
            return "sun.max"
        case 800..<900:
            return "cloud.sun.fill"
            
        default:
            return ""
        }
    }
    
    
}

// MARK: - Location Delegate

extension WeatherViewController: CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let lat = String(format: "%0.2f", (location.coordinate.latitude))
            let lon = String(format: "%0.2f", (location.coordinate.longitude))
            print("location=\(lat),\(lon)")
            self.weatherManager.fetchWeatherByCord(lat: "\(lat)", lon: "\(lon)")
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("error location")
    }
}
