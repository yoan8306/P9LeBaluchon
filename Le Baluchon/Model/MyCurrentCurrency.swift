//
//  MyCurrentCurrency.swift
//  Le Baluchon
//
//  Created by Yoan on 17/03/2022.
//

import Foundation

struct MyCurrentCurrency {

    var rates: [String: Float] = [:]
    var symbols: [String: String] = [:]
    var updatedDate: Date = Date()
    var usdRate: Float? {
        rates["USD"]
    }

    init(rates: [String: Float] = [:], symbols: [String: String] = [:], updatedDate: Date = Date()) {
       self.rates = rates
       self.symbols = symbols
        self.updatedDate = updatedDate
   }

     func convertDateUpdate(updatedDate: Date) -> String {
        let mydate = DateFormatter()
        mydate.dateFormat = "EEEE, d MMM yyyy HH:mm"
       return mydate.string(from: updatedDate)
    }

    func sortListKey (myCurrency: [String: Float]) -> [String] {
        var listKey: [String] = []
        for (key, _) in myCurrency {
            listKey.append(key)
        }
        listKey.sort()
        return listKey
    }

    func sortlistSymbols (myCurrency: [String: String]) -> [String] {
        var listSymbols: [String] = []
        for (key, _) in myCurrency {
            listSymbols.append(key)
        }
        listSymbols.sort()
        return listSymbols
    }
}
