//
//  MoneyRatesServices.swift
//  Le Baluchon
//
//  Created by Yoan on 15/03/2022.
//

import Foundation

class MoneyRatesService {
    static var shared = MoneyRatesService()
    private init() {}
    
    private static let moneyRatesUrl = URL(string: "http://data.fixer.io/api/symbols?access_key=\(ApiKeys.MoneyRates)")!
    private static let deviseMoneyUrl = URL(string: "http://data.fixer.io/api/latest?access_key=\(ApiKeys.MoneyRates)")!
    
    
    private var task: URLSessionDataTask?
    
    func getSymbolsCurrency(callBack: @escaping (Bool, MyCurrentCurrency?) -> Void) {
        let session = URLSession(configuration: .default)
        task?.cancel()
        
        task = session.dataTask(with: MoneyRatesService.moneyRatesUrl) { (data, response, error) in
            DispatchQueue.main.async { [self] in
                guard let data = data, error == nil else {
                    callBack(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callBack(false, nil)
                    return
                }
                guard let listSymbols = try? JSONDecoder().decode(Symbols.self, from: data) else {
                    callBack(false, nil)
                    return
                }
        
                getDeviseCurrency { (data) in
                    guard let data = data else {
                        callBack(false, nil)
                        return
                    }
                    let currentCurrency = MyCurrentCurrency(rates: data.rates, symbols: listSymbols.symbols, updatedDate: Date(timeIntervalSince1970: TimeInterval(data.timestamp)))
                        callBack(true, currentCurrency)
                }
            }
        }
        task?.resume()
    }
    
    func getDeviseCurrency(completionHandler: @escaping (Devise?)->Void) {
        let session = URLSession(configuration: .default)
        task?.cancel()
        
        task = session.dataTask(with: MoneyRatesService.deviseMoneyUrl) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completionHandler(nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler(nil)
                    return
                }
                guard let listDevise = try? JSONDecoder().decode(Devise.self, from: data) else {
                    completionHandler(nil)
                    return
                }
                completionHandler(listDevise)
            }
        }
        task?.resume()
        
    }
    
}
