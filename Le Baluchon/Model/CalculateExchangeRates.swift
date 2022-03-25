//
//  CalculateExangesRates.swift
//  Le Baluchon
//
//  Created by Yoan on 24/03/2022.
//

import Foundation

class CalculateExchangeRates {
    func calcul(fromBase: Float?, textFieldValue: String?, dollarValue: Float?) -> String {
        guard let textFieldValue = textFieldValue else {
            return "0"
        }

        guard let fromBase = fromBase, let floatValue = Float(textFieldValue), let dollarValue = dollarValue else {
            return "0"
        }
        return String((floatValue/fromBase) * dollarValue)
    }
}
