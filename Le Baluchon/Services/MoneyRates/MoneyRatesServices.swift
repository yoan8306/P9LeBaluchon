//
//  MoneyRatesServices.swift
//  Le Baluchon
//
//  Created by Yoan on 15/03/2022.
//

import Foundation

// Saut des lignes entre variables / méthodes
class MoneyRatesService {
    static var shared = MoneyRatesService(sessionTask: SessionTask.shared)
    var sessionTask: SessionTaskProtocol

    init(sessionTask: SessionTaskProtocol) {
        self.sessionTask = sessionTask
    }

    // les 2 urls sont les mêmes
    private static let moneyRatesUrl =
    URL(string: "http://data.fixer.io/api/symbols?access_key=\(ApiKeys.moneyRatesKey)")!
    private static let deviseMoneyUrl =
    URL(string: "http://data.fixer.io/api/latest?access_key=\(ApiKeys.moneyRatesKey)")!

    func getSymbolsCurrency(callBack: @escaping (Result<SymbolsDTO, Error>) -> Void) {
        sessionTask.sendTask(url: MoneyRatesService.moneyRatesUrl) { result in
            switch result {
            case .success(let data):

                guard let listSymbols = try? JSONDecoder().decode(SymbolsDTO.self, from: data) else {
                    callBack(.failure(APIError.decoding))
                    return
                }
                callBack(.success(listSymbols))

            case .failure(let error):
                callBack(.failure(error))
            }
        }
    }

      func getDeviseCurrency(completionHandler: @escaping (Result<DeviseDTO, Error>) -> Void) {
       sessionTask.sendTask(url: MoneyRatesService.deviseMoneyUrl) { result in
            switch result {
            case .success(let data):
                guard let listDevise = try? JSONDecoder().decode(DeviseDTO.self, from: data) else {
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
