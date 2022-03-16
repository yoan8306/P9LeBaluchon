//
//  Symbols.swift
//  Le Baluchon
//
//  Created by Yoan on 15/03/2022.
//

import Foundation
struct Symbols: Decodable {
    let success: Bool
    let symbols: [String : String]
    
    enum CodingKeys: String,CodingKey {
        case success
        case symbols
    }
    
    func createSymbolsList(dictionnary : [String : String]) -> [Currency] {
        var list = [Currency]()
        for (keys, values) in dictionnary {
           let currency = Currency(code: keys, name: values)
            list.append(currency)
        }
        let listArr = list.sorted(by: { $0.name < $1.name})
        return listArr
    }
}
struct Currency: Decodable {
    var code: String
    var name: String
}
