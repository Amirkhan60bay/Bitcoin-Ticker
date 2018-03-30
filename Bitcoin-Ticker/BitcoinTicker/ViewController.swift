
import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["KZT","AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""
    
    //IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
    
    
    // UIPickerView delegate methods
    func numberOfComponents(in pickerview: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerview: UIPickerView, numberOfRowsInComponent: Int) -> Int {
        return currencyArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        getBitcoinRateData(url: finalURL)
    }
    
    
        //Networking
        func getBitcoinRateData(url: String) {
    
            Alamofire.request(url, method: .get)
                .responseJSON { response in
                    if response.result.isSuccess {
    
                        print("Sucess! Got the rate data")
                        let rateJSON : JSON = JSON(response.result.value!)
    
                        self.updateRateData(json: rateJSON)
    
                    } else {
                        print("Error: \(String(describing: response.result.error))")
                        self.bitcoinPriceLabel.text = "Connection Issues"
                    }
                }
    
        }
    
    
    
    
    
        //JSON Parsing
        func updateRateData(json : JSON) {
    
            if let rateResult = json["ask"].double {
                
                bitcoinPriceLabel.text = String(rateResult)
                
            }
    
            else {
            
                bitcoinPriceLabel.text = "Rate is Unavailable"
            }
        }
}
