//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoinInfo(manager: CoinManager, info: CoinInfo)
    func didFailedWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "0D68574D-46EE-4216-A6EB-806A274ABB83"
    
    let currencyArray = ["AUD", "BRL","CAD", "CNY", "EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    //  CNY is not recognized
    
    var delegate: CoinManagerDelegate?

    func getCoinPrice(for currency: String){
        // get currency code and process to get data from the API.
        // print("passed currency : \(currency)")
        let url = baseURL + "/\(currency)" + "?apikey=\(apiKey)"
        
        performRequest(urlString: url)
    }
    
    func performRequest(urlString: String) {
        // create URL
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handle(data: response: error:))
            task.resume()
        }
        
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            // if failed with error
            delegate?.didFailedWithError(error: error!)
            return
        }
        
        if let safeData = data {
            // parse the incoming safeData from its JSON format
            if let coinInfo = parseJSON(coinData: safeData) {
                delegate?.didUpdateCoinInfo(manager: self, info: coinInfo)
            }
            
        }
    }
    
    func parseJSON(coinData: Data) -> CoinInfo? {
        // this will parse the incoming JSON data from the coinAPI server
        let decoder = JSONDecoder()
        
        do {
            // try to decode the JSON formatted data
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            // build the coinInfo type object.
            let quote = decodedData.asset_id_quote
            let rate = String(format: "%.2f", decodedData.rate)
            let coinInfo = CoinInfo(currency: quote, rate: rate)
            return coinInfo
        } catch {
            // if error call func didFailedWithError
            delegate?.didFailedWithError(error: error)
            return nil
        }
    }
}
