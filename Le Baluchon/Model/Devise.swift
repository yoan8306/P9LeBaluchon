//
//  Devise.swift
//  Le Baluchon
//
//  Created by Yoan on 16/03/2022.
//

import Foundation

struct Devise: Decodable {
    let success: Bool
    let timestamp: Int
    let base: String
    let date: String 
    let rates: [String: Float]
    
    func createDeviseList(dictionnary : [String : Float]) -> [CurrencyValue] {
        var list = [CurrencyValue]()
        for (keys, value) in dictionnary {
           let currency = CurrencyValue(code: keys, values: value)
            list.append(currency)
        }
        let listArr = list.sorted(by: { $0.code < $1.code})
        return listArr
    }
}
struct CurrencyValue: Decodable {
    var code: String
    var values: Float
}

struct ConcatenateValues {
    
    
}
