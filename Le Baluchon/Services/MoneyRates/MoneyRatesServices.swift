//
//  MoneyRatesServices.swift
//  Le Baluchon
//
//  Created by Yoan on 15/03/2022.
//

import Foundation

class MoneyRatesService {
    static var shared = MoneyRatesService(sessionTask: SessionTask.shared)
    var sessionTask: SessionTaskProtocol

    init(sessionTask: SessionTaskProtocol) {
        self.sessionTask = sessionTask
    }

    private static let moneyRatesUrl = URL(string: "http://data.fixer.io/api/symbols?access_key=\(ApiKeys.moneyRates)")!
    private static let deviseMoneyUrl = URL(string: "http://data.fixer.io/api/latest?access_key=\(ApiKeys.moneyRates)")!

    func getSymbolsCurrency(callBack: @escaping (Result<Symbols, Error>) -> Void) {
        sessionTask.sendTask(url: MoneyRatesService.moneyRatesUrl) { result in
            switch result {
            case .success(let data):

                guard let listSymbols = try? JSONDecoder().decode(Symbols.self, from: data) else {
                    callBack(.failure(APIError.decoding))
                    return
                }
                callBack(.success(listSymbols))

            case .failure(let error):
                callBack(.failure(error))
            }
        }
    }

      func getDeviseCurrency(completionHandler: @escaping (Result<Devise, Error>) -> Void) {
       sessionTask.sendTask(url: MoneyRatesService.deviseMoneyUrl) { result in
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
