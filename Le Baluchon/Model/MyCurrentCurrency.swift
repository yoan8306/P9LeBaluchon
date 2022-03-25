//
//  MyCurrentCurrency.swift
//  Le Baluchon
//
//  Created by Yoan on 17/03/2022.
//

import Foundation

struct MyCurrentCurrency {
    let rates: [String: Float]
    let symbols: [String: String]
    let updatedDate: Date

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

struct Devise: Decodable {
    let success: Bool
    let timestamp: Int
    let base: String
    let date: String
    let rates: [String: Float]
}

struct Symbols: Decodable {
    let success: Bool
    let symbols: [String: String]
}
