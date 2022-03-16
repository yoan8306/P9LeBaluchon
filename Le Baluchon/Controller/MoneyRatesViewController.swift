//
//  MoneyRatesViewController.swift
//  Le Baluchon
//
//  Created by Yoan on 15/03/2022.
//

import UIKit

class MoneyRatesViewController: UIViewController {

    @IBAction func buttonTest(_ sender: UIButton) {
        MoneyRatesService.getSymbolsCurrency()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    


}
