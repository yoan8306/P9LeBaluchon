//
//  HideKeyboard.swift
//  Le Baluchon
//
//  Created by Yoan on 24/03/2022.
//

import Foundation
import UIKit
extension UITextField {
    func addDoneButton(title: String = "Done", target: Any, selector: Selector) {

        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 30.0))// 1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)// 2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)// 3
        toolBar.setItems([flexible, barButton], animated: false)// 4
        self.inputAccessoryView = toolBar// 5
    }

    func calculRates(fromBase: Float?, to dollarValue: Float?) -> String {
        guard let textFieldValue = text,
                let fromBase = fromBase,
                let floatValue = Float(textFieldValue),
                let dollarValue = dollarValue else {
            return "0"
        }

        return String((floatValue/fromBase) * dollarValue)
    }

}
