//
//  MoneyRatesServices.swift
//  Le Baluchon
//
//  Created by Yoan on 15/03/2022.
//

import Foundation

class MoneyRatesService {
    
    static func getSymbolsCurrency() {
        let session = URLSession(configuration: .default)
        
        guard let moneyRatesUrl = URL(string: "http://data.fixer.io/api/symbols?access_key=\(ApiKeys.MoneyRates)") else { return }
        print(moneyRatesUrl)
        
        let request = URLRequest(url: moneyRatesUrl)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
               print("Error1")
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
               print("Error2")
                return
            }
            guard let responseJSON = try? JSONDecoder().decode(Symbols.self, from: data) else {
                print("Error3")
                return
            }
            print(responseJSON)
        }
        task.resume()
    }
}
