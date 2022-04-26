//
//  FakeResponseMoneyRatesData.swift
//  Le BaluchonTests
//
//  Created by Yoan on 28/03/2022.
//

import Foundation

class FakeResponseMoneyRatesData {
// MARK: - Error
    class MoneyRatesError: Error {}
    let moneyError = MoneyRatesError()

// MARK: - Data
    var symbolsCorrectData: Data {
        let bundle = Bundle(for: FakeResponseMoneyRatesData.self)
        let url = bundle.url(forResource: "Symbols", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    var deviseCorrectData: Data {
        let bundle = Bundle(for: FakeResponseMoneyRatesData.self)
        let url = bundle.url(forResource: "Devise", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    var moneyIncorrectData = "I'm a bad json".data(using: .utf8)
}
