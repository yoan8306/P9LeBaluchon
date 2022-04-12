//
//  MyCurrentCurrency.swift
//  Le Baluchon
//
//  Created by Yoan on 17/03/2022.
//

import Foundation

struct MyCurrentCurrency {

    var rates: [String: Float]
    var symbols: [String: String]
    var updatedDate: Date
    var usdRate: Float? {
        rates["USD"]
    }

    init() {
        rates = [:]
        symbols = [:]
        updatedDate = Date()
    }

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

    func sortListKey () -> [String] {
        var listKey: [String] = []
        for (key, _) in rates {
            listKey.append(key)
        }
        listKey.sort()
        return listKey
    }

    func convertMoneyToDollar(fromSymbol: String, value: Float) -> String {

        guard   let rate = rates[fromSymbol],
                let dollarValue = usdRate else {
            return "0"
        }

        return String((value/rate) * dollarValue)
    }

}
