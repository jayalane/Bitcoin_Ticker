//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Kushlani Jayasinha on 02/10/2018
//
//

import UIKit
import Alamofire
import SwiftyJSON



class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["USD","AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","LKR","MXN","NOK","NZD","RON","RUB","SEK","SGD","ZAR"]
    var finalURL = ""  // eg. baseURL+USD

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    var data : UIPickerViewDataSource?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        getBitcoinData(url: "\(baseURL)USD") // set to US $ initially
    }
        

    // UIPickerView delegate methods
    // ***************************************************************/

    // number of columns in Picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // number of rows in picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    // row titles
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return currencyArray[row]
    }
    // which row was picked
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("row: \(row)")
        
        finalURL = "\(baseURL)\(currencyArray[row])"
        getBitcoinData(url: finalURL)
        
    }
    
   
    // Networking to get Bitcoin Data using Alamofire
    //***************************************************************/
    
    func getBitcoinData(url: String) {
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                let resJSON = JSON(response.value!)
                self.updateUI(json : resJSON)
            }
            else {
                print("Network Issues")
            }
        }
    }
    
    
    func updateUI(json : JSON) {
        let priceStr : String = String(json["ask"].double!)
        print("price: \(priceStr)")
        bitcoinPriceLabel.text = priceStr
        
     }
}
    
    
