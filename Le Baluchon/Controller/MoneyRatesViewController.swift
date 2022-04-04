//
//  MoneyRatesViewController.swift
//  Le Baluchon
//
//  Created by Yoan on 15/03/2022.
//

import UIKit

class MoneyRatesViewController: UIViewController {
    
    // MARK: - Properties
    var myCurrency = MyCurrentCurrency()
    var listSymbol = Symbols()
    var listDevise = Devise()
    var listKey: [String] = []
    private var headerTitle = "Value for 1 EURO"
    
    // MARK: - @IBOutlet
    @IBOutlet weak var symbolFromLabel: UILabel!
    @IBOutlet weak var symbolToLabel: UILabel!
    @IBOutlet weak var updatedDateLabel: UILabel!
    @IBOutlet weak var resultConvertLabel: UILabel!
    @IBOutlet weak var currencyTableView: UITableView!
    @IBOutlet weak var activityController: UIActivityIndicatorView!
    @IBOutlet weak var valueSymbolFromTextField: UITextField!
    
    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        listKey = myCurrency.sortListKey(myCurrency: myCurrency.rates)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callMoneyRatesService()
        listKey = myCurrency.sortListKey(myCurrency: self.myCurrency.rates)
        currencyTableView.reloadData()
        valueSymbolFromTextField.addDoneButton(target: self, selector: #selector(tapDone(sender:)))
    }
    
    // MARK: - @IBAction
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
        convertToUSD()
    }
    
    @IBAction func dissMissKeyboard(_ sender: UITapGestureRecognizer) {
        valueSymbolFromTextField.resignFirstResponder()
        convertToUSD()
    }
}

private extension MoneyRatesViewController {
    // MARK: - Private function
    
    func callMoneyRatesService() {
        callGetSymbolService()
    }
    
    func callGetSymbolService() {
        MoneyRatesService.shared.getSymbolsCurrency {[weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let mySymbol) :
                self.listSymbol = mySymbol
                self.callGetDevise()
                
            case .failure(let error) :
                self.presentAlert(alertMessage: error.localizedDescription)
            }
        }
    }
    
    func callGetDevise() {
        MoneyRatesService.shared.getDeviseCurrency { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let myDevise):
                self.listDevise = myDevise
                self.createMyCurrency()
                
            case .failure(let error):
                self.presentAlert(alertMessage: error.localizedDescription)
            }
        }
    }
    
    func createMyCurrency() {
        guard let rates = listDevise.rates,
              let symbol = listSymbol.symbols,
              let timeStamp = listDevise.timestamp else {
                  return
              }
        
        let dateUpdated = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let currentCurrency = MyCurrentCurrency(rates: rates, symbols: symbol, updatedDate: dateUpdated)
        
        self.myCurrency = currentCurrency
        let updateDate = myCurrency.updatedDate
        self.listKey = myCurrency.sortListKey(myCurrency: self.myCurrency.rates)
        self.currencyTableView.reloadData()
        self.updatedDateLabel.text = myCurrency.convertDateUpdate(updatedDate: updateDate)
        self.activityController.isHidden = true
    }
    
    func convertToUSD() {
        guard let symbol = symbolFromLabel.text, listKey.contains(symbol) else {
            return
        }
        resultConvertLabel.text = valueSymbolFromTextField.calculRates(fromBase: myCurrency.rates[symbol],
                                                                       to: myCurrency.usdRate)
    }
    
    func presentAlert (alertTitle title: String = "Error", alertMessage message: String,
                       buttonTitle titleButton: String = "Retry") {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionRetry = UIAlertAction(title: titleButton, style: .default) {_ in
            self.callMoneyRatesService()
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .destructive) {_ in
            self.activityController.stopAnimating()
        }
        
        alertVC.addAction(actionCancel)
        alertVC.addAction(actionRetry)
        present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - tableView Currency
extension MoneyRatesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCurrency.sortListKey(myCurrency: myCurrency.rates).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currency = listKey[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath)
                as? CurrencyTableViewCell else {
                    return UITableViewCell()
                }
        
        cell.configureCell(key: currency,
                           countryReference: myCurrency.symbols[currency],
                           value: myCurrency.rates[currency])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard symbolFromLabel.text != listKey[indexPath.row] else {
            return
        }
        let keySelected = listKey[indexPath.row]
        symbolFromLabel.text = keySelected
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitle
    }
}
