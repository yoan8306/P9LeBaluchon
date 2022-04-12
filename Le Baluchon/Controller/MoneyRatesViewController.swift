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
    override func viewDidLoad() {
        super.viewDidLoad()
        callMoneyRatesService()
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
                self.callGetDevise(symbols: mySymbol.symbols ?? [:])

            case .failure(let error) :
                self.presentAlert(alertMessage: error.localizedDescription)
            }
        }
    }

    func callGetDevise(symbols: [String: String]) {
        MoneyRatesService.shared.getDeviseCurrency { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let myDevise):
                self.myCurrency = MyCurrentCurrency(devise: myDevise, symbols: symbols)
                self.listKey = self.myCurrency.sortListKey()
                self.updateView()
            case .failure(let error):
                self.presentAlert(alertMessage: error.localizedDescription)
            }
        }
    }

    func updateView() {
        currencyTableView.reloadData()
        updatedDateLabel.text = myCurrency.convertDateUpdate()
        activityController.isHidden = true
    }

    func convertToUSD() {
        guard let symbol = symbolFromLabel.text, listKey.contains(symbol),
              let value = valueSymbolFromTextField.text, let floatValue = Float(value) else {
                  return
              }

        resultConvertLabel.text =  myCurrency.convertMoneyToDollar(fromSymbol: symbol, value: floatValue )
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
        return listKey.count
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
