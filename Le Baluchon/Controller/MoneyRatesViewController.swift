//
//  MoneyRatesViewController.swift
//  Le Baluchon
//
//  Created by Yoan on 15/03/2022.
//

import UIKit

class MoneyRatesViewController: UIViewController {
    var myCurrency = MyCurrentCurrency(rates: ["No key" : 0.0], symbols: ["" : ""], updatedDate: Date())
    var keyForArray : [String] = []
    
    @IBOutlet weak var currencyTableView: UITableView!
    
    
    // MARK: -Life cycle
    override func viewWillAppear(_ animated: Bool) {
        listArr()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MoneyRatesService.shared.getSymbolsCurrency {(succes, myCurrency) in
            if succes, let myCurrency = myCurrency {
                self.myCurrency = myCurrency
                self.listArr()
                self.currencyTableView.reloadData()
                
            } else {
                self.presentAlert_Alert(alertTitle: "Error network", alertMessage: "They an problem", buttonTitle: "ok", alertStyle: .cancel)
            }
        }
    }
    
    
    // MARK: - Private function
    
    private func presentAlert_Alert (alertTitle title: String, alertMessage message: String,buttonTitle titleButton: String, alertStyle style: UIAlertAction.Style ) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: titleButton, style: style, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
    
    private func listArr() {
        for (key,_) in myCurrency.rates {
            keyForArray.append(key)
        }
    }
}


// MARK: - tableView Currency
extension MoneyRatesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return myCurrency.rates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currency = keyForArray[indexPath.row]
        guard let countryReference = myCurrency.symbols[currency] else {
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as? CurrencyTableViewCell else {
            return UITableViewCell()
        }
        guard let value = myCurrency.rates[currency] else {
            return UITableViewCell()
        }
        
        cell.configureCell(key: currency, countryReference: countryReference, value: value)
        return cell
        
    }
    
    
    
    
    
}
