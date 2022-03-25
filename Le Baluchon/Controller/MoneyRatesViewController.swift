//
//  MoneyRatesViewController.swift
//  Le Baluchon
//
//  Created by Yoan on 15/03/2022.
//

import UIKit

class MoneyRatesViewController: UIViewController {

    // MARK: - Properties
//        var myCurrency = MyCurrentCurrency(rates: ["No key": 0], symbols: ["": ""], updatedDate: Date())
    var myCurrency = MyCurrentCurrency(rates: CurrencyTest().rates, symbols: CurrencyTest().symbols, updatedDate: Date(timeIntervalSince1970: TimeInterval(CurrencyTest().timeStamp)))
    var listKey: [String] = []
    var convertRate = CalculateExchangeRates()

    // MARK: - @IBOutlet
    @IBOutlet weak var symbolFromLabel: UILabel!
    @IBOutlet weak var symbolToLabel: UILabel!
    @IBOutlet weak var updatedDateLabel: UILabel!
    @IBOutlet weak var resultConvertLabel: UILabel!
    @IBOutlet weak var currencyTableView: UITableView!
    @IBOutlet weak var valueSymbolFromTextField: UITextField!

    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        listKey = myCurrency.sortListKey(myCurrency: myCurrency.rates)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeTest()
//        callMoneyRatesService()
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

    // MARK: - Private function

    private func makeTest() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMM yyyy HH:mm"
        updatedDateLabel.text = "Last updated: " + dateFormatter.string(from: myCurrency.updatedDate)
    }

    private func callMoneyRatesService() {
        MoneyRatesService.shared.getSymbolsCurrency {[weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success(let myCurrency) :
                let updateDate = myCurrency.updatedDate
                self.myCurrency = myCurrency
                self.listKey = myCurrency.sortListKey(myCurrency: self.myCurrency.rates)
                self.currencyTableView.reloadData()
                self.updatedDateLabel.text = myCurrency.convertDateUpdate(updatedDate: updateDate)

            case .failure(let error) :
                self.presentAlert(alertMessage: error.localizedDescription)
            }
        }
    }

    private func convertToUSD() {
        guard let symbol = symbolFromLabel.text, listKey.contains(symbol) else {
            return
        }
        resultConvertLabel.text =  convertRate.calcul(fromBase: myCurrency.rates[symbol],
                                                      textFieldValue: valueSymbolFromTextField.text,
                                                      dollarValue: myCurrency.rates["USD"])
    }

    private func presentAlert (alertTitle title: String = "Error", alertMessage message: String,
                               buttonTitle titleButton: String = "Ok",
                               alertStyle style: UIAlertAction.Style = .cancel ) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: titleButton, style: style, handler: nil)
        alertVC.addAction(action)
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

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard symbolFromLabel.text != listKey[indexPath.row] else {
            return
        }
        let cell = tableView.cellForRow(at: indexPath)
        let keySelected = listKey[indexPath.row]

        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
            symbolFromLabel.text = keySelected
        } else {
            cell?.accessoryType = .checkmark
            symbolFromLabel.text = keySelected
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Value for 1 EURO"
    }
}

extension MoneyRatesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        valueSymbolFromTextField.resignFirstResponder()
        return true
    }
}
