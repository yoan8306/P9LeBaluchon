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
                                              height: 30.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }

}
