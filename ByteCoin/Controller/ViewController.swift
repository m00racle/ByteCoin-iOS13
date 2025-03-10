//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
// outlets
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    // connect to coinManager struct:
    var coinManager = CoinManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        coinManager.getCoinPrice(for: coinManager.currencyArray[0])
    }
    
}

// MARK: UIPickerView stubs
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    // stubs from UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // number of columns in the picker
        return 1
    }
    
    // set how many rows in the picker view.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // number of rows in picker = number of availabel currency
        return coinManager.currencyArray.count
    }
    
    // set all currency names in the picker view which comes from coinManager struct's currencyArray
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    // set what happen if I tap one of the currency in pickerView
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // this is what happen if I select a row in pickerView
        let selectedCoin = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCoin)
    }
}

// MARK: CoinManagerDelegates stub
extension ViewController: CoinManagerDelegate {
    // coinManagerDelegate stubs:
    func didUpdateCoinInfo(manager: CoinManager, info: CoinInfo) {
        
        // USING queue
        DispatchQueue.main.async {
            self.currencyLabel.text = info.currency
            self.bitcoinLabel.text = info.rate
        }
    }
    
    func didFailedWithError(error: Error) {
        // process the error
        print(error)
        DispatchQueue.main.async {
            // put back the process to main thread and then put it into bitcoinLabel
            self.bitcoinLabel.text = "Not Available!"
            self.currencyLabel.text = ""
        }
    }
}
