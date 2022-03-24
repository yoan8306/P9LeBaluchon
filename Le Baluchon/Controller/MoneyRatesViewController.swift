//
//  MoneyRatesViewController.swift
//  Le Baluchon
//
//  Created by Yoan on 15/03/2022.
//

import UIKit

class MoneyRatesViewController: UIViewController {

    // MARK: - Properties
    var myCurrency = MyCurrentCurrency(rates: CurrencyTest().rates, symbols: CurrencyTest().symbols, updatedDate: Date(timeIntervalSince1970: TimeInterval(CurrencyTest().timeStamp)))
    var listKey: [String] = []

    // MARK: - @IBOutlet
    @IBOutlet weak var symbolFromLabel: UILabel!
    @IBOutlet weak var symbolToLabel: UILabel!
    @IBOutlet weak var updatedDateLabel: UILabel!
    @IBOutlet weak var currencyTableView: UITableView!

    @IBOutlet weak var valueSymbolFromTextField: UITextField!

    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        listKey = myCurrency.sortListKey(myCurrency: myCurrency.rates)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        listKey = myCurrency.sortListKey(myCurrency: self.myCurrency.rates)
        currencyTableView.reloadData()
        updatedDateLabel.text = dateFormatter.string(from: self.myCurrency.updatedDate)
        valueSymbolFromTextField.addDoneButton(target: self, selector: #selector(tapDone(sender:)))
    }

    // MARK: - @IBAction

    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    @IBAction func dissMissKeyboard(_ sender: UITapGestureRecognizer) {
        valueSymbolFromTextField.resignFirstResponder()
    }

    // MARK: - Private function

    private func callMoneyRatesService() {
        let dateFormatter = DateFormatter()

        MoneyRatesService.shared.getSymbolsCurrency {[weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let myCurrency) :
                    self.myCurrency = myCurrency
                    self.listKey = myCurrency.sortListKey(myCurrency: self.myCurrency.rates)
                    self.currencyTableView.reloadData()
                    self.updatedDateLabel.text = dateFormatter.string(from: self.myCurrency.updatedDate)

            case .failure(let error) :
                self.presentAlert_Alert(alertTitle: "Error", alertMessage: error.localizedDescription, buttonTitle: "Ok", alertStyle: .cancel)
            }
        }
    }
    private func presentAlert_Alert (alertTitle title: String, alertMessage message: String,
                                     buttonTitle titleButton: String, alertStyle style: UIAlertAction.Style ) {
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

            guard let countryReference = myCurrency.symbols[currency] else {
                return UITableViewCell()
            }

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath)
                    as? CurrencyTableViewCell else {
                return UITableViewCell()
            }
            guard let value = myCurrency.rates[currency] else {
                return UITableViewCell()
            }

            cell.configureCell(key: currency, countryReference: countryReference, value: value)
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

}

extension MoneyRatesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        valueSymbolFromTextField.resignFirstResponder()
        return true
    }

}
