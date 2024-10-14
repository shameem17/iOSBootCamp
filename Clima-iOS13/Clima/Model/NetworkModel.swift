//
//  NetworkModel.swift
//  Clima
//
//  Created by Shameem on 6/10/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate{
    func updateUIData(withData weatherData: Weather)
    func showError(error: Error)
}

enum APIError: Error{
    case badURL
    case decodingError
    case badResponse
    case unknown
}

struct WeatherManager{
    var delegate: WeatherManagerDelegate?
    let baseUrl: String = "https://api.openweathermap.org/data/2.5/weather?appid=7bcd428df261afffce19a53499f2a91b&units=metric"
    func fetchWeatherByCity(cityName: String){
        print("api calling")
        let urlString = "\(baseUrl)&q=\(cityName)"
        if let url = URL(string: urlString){
            self.performUrlAction(with: url)
        }else{
            self.delegate?.showError(error: APIError.badURL)
        }
    }
    
    func fetchWeatherByCord(lat: String, lon: String){
        let urlString = "\(baseUrl)&lat=\(lat)&lon=\(lon)"
        if let url = URL(string: urlString){
            self.performUrlAction(with: url)
        }else{
            self.delegate?.showError(error: APIError.badURL)
        }
    }
    
    private func performUrlAction(with url: URL){
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
       let taks = URLSession(configuration: .default).dataTask(with: request) {(data, response, error)  in
           //print("response code =\(response)")
            if (error == nil){
                self.decodeJson(data: data)
            }else{
                self.delegate?.showError(error: APIError.unknown)
            }
        }
        taks.resume()
    }
    
    private func decodeJson(data: Data?){
        if let data = data{
            do{
                let jsonData =  try JSONDecoder().decode(Weather.self, from: data)
                self.delegate?.updateUIData(withData: jsonData)
            }catch{
                self.delegate?.showError(error: APIError.decodingError)
            }
        }else{
            self.delegate?.showError(error: APIError.badResponse)
        }

    }
}
