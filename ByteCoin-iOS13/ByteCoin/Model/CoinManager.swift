//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Codable{
    let rate: Double
}

protocol CoinManagerDelegate{
    func showError(error: Error)
    func showExchange(data: CoinData)
}
enum APIError: Error{
    case badUrl
    case badResponse
    case decodingError
    case unKnown
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "your api key here"   //"75EE1FCD-4773-4500-BD57-19DD586C213E"
    
    let currencyArray = ["AUD", "BD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    
    func fetchExchange(for currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        guard let url = URL(string: urlString) else{
            self.delegate?.showError(error: APIError.badUrl)
            return
        }
        self.getExchange(with: url)
    }
    
    private func getExchange(with url: URL){
       let task = URLSession.shared.dataTask(with: url) { data, response, error in
           if error == nil{
               if let data = data{
                   self.parseJson(from: data)
               }
           }else{
               self.delegate?.showError(error: APIError.unKnown)
           }
        }
        task.resume()
    }
    
    private func parseJson(from data: Data){
//        let pData = String(data: data, encoding: .utf8)
//        print("got data =\(pData)")
        do{
            let jsonData = try JSONDecoder().decode(CoinData.self, from: data)
            self.delegate?.showExchange(data: jsonData)
        }catch{
            self.delegate?.showError(error: APIError.decodingError)
        }
    }
}
