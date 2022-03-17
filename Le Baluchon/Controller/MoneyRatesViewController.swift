//
//  MoneyRatesViewController.swift
//  Le Baluchon
//
//  Created by Yoan on 15/03/2022.
//

import UIKit

class MoneyRatesViewController: UIViewController {

    @IBAction func buttonTest(_ sender: UIButton) {
        MoneyRatesService.shared.getSymbolsCurrency {(succes, myCurrency) in
            if succes, let myCurrency = myCurrency {
                print(myCurrency.symbols, myCurrency.rates)
            } else {
                self.presentAlert_Alert(alertTitle: "Error network", alertMessage: "They an problem", buttonTitle: "ok", alertStyle: .cancel)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    private func presentAlert_Alert (alertTitle title: String, alertMessage message: String,buttonTitle titleButton: String, alertStyle style: UIAlertAction.Style ) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: titleButton, style: style, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }


}
