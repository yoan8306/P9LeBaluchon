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

    private static let moneyRatesUrl = URL(string: "http://data.fixer.io/api/symbols?access_key=\(ApiKeys.moneyRates)")!
    private static let deviseMoneyUrl = URL(string: "http://data.fixer.io/api/latest?access_key=\(ApiKeys.moneyRates)")!

    private var task: URLSessionDataTask?

    func getSymbolsCurrency(callBack: @escaping (Result<MyCurrentCurrency, Error>) -> Void) {
        SessionTask.shared.sendTask(url: MoneyRatesService.moneyRatesUrl) { result in
            switch result {
            case .success(let data):

                guard let listSymbols = try? JSONDecoder().decode(Symbols.self, from: data) else {
                        callBack(.failure(APIError.decoding))
                    return
                }

                self.getDeviseCurrency { result in
                    switch result {
                    case .success(let result):
                        let currentCurrency = MyCurrentCurrency(rates: result.rates,
                                                                symbols: listSymbols.symbols,
                                                                updatedDate:
                                                                    Date(timeIntervalSince1970: TimeInterval(result.timestamp)))
                        callBack(.success(currentCurrency))

                    case .failure(let error):
                        callBack(.failure(error))
                    }
                }

            case .failure(let error):
                callBack(.failure(error))
            }
        }
    }

    private  func getDeviseCurrency(completionHandler: @escaping (Result<Devise, Error>) -> Void) {

        SessionTask.shared.sendTask(url: MoneyRatesService.deviseMoneyUrl) { result in
            switch result {
            case .success(let data):
                guard let listDevise = try? JSONDecoder().decode(Devise.self, from: data) else {
                    completionHandler(.failure(APIError.decoding))
                    return
                }
                completionHandler(.success(listDevise))
            case .failure(let error) :
                completionHandler(.failure(error))
            }
        }
    }
}
