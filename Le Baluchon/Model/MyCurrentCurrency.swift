//
//  MyCurrentCurrency.swift
//  Le Baluchon
//
//  Created by Yoan on 17/03/2022.
//

import Foundation

struct MyCurrentCurrency {
// MARK: - Properties
    var rates: [String: Float]
    var symbols: [String: String]
    var updatedDate: Date
    var usdRate: Float? {
        rates["USD"]
    }

    /// init for application
    init() {
        rates = [:]
        symbols = [:]
        updatedDate = Date()
    }

    /// init for test
    /// - Parameters:
    ///   - devise: deviseDTO from json file
    ///   - symbols: array string from symbolDTO json file
    init(devise: DeviseDTO, symbols: [String: String]) {
        let dateUpdated = Date(timeIntervalSince1970: TimeInterval(devise.timestamp))
        self.rates = devise.rates
       self.symbols = symbols
        self.updatedDate = dateUpdated
   }

     func convertDateUpdate() -> String {
        let mydate = DateFormatter()
        mydate.dateFormat = "EEEE, d MMM yyyy HH:mm"
       return mydate.string(from: updatedDate)
    }

    /// sort symbol in alphapbet
    /// - Returns: array sorted
    func sortListKey () -> [String] {
        var listKey: [String] = []
        for (key, _) in rates {
            listKey.append(key)
        }
        listKey.sort()
        return listKey
    }

    /// Formula for convert any devise to dollar (value / rate)  convert in euro the value origin and after multiply in dollar value
    /// - Parameters:
    ///   - fromSymbol: Devise origin
    ///   - value: Value in textField
    /// - Returns: Value in dollar
    func convertMoneyToDollar(fromSymbol: String, value: Float) -> String {

        guard   let rate = rates[fromSymbol],
                let dollarValue = usdRate else {
            return "0"
        }

        return String((value/rate) * dollarValue)
    }

}
