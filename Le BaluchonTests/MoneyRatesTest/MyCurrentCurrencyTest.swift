//
//  MoneyRatesServiesTestCase.swift
//  Le BaluchonTests
//
//  Created by Yoan on 28/03/2022.
//

import XCTest
@testable import Le_Baluchon

class MycurrentCurrencyTest: XCTestCase {
    let data = FakeResponseMoneyRatesData()
    var listSymbols: SymbolsDTO? {
        guard let symbols = try? JSONDecoder().decode(SymbolsDTO.self, from: data.symbolsCorrectData) else {
            return nil
        }
        return symbols
    }

    var listDevise: DeviseDTO? {
        guard let devises = try? JSONDecoder().decode(DeviseDTO.self, from: data.deviseCorrectData) else {
            return nil
        }
        return devises
    }
    var myCurrency = MyCurrentCurrency()

    override func setUpWithError() throws {
        guard let listDevise = listDevise else {
            return
        }
        guard let listSymbols = listSymbols else {
            return
        }
        myCurrency = MyCurrentCurrency(devise: listDevise, symbols: listSymbols.symbols!)
    }

    func testGivenCorrectData_WhenPassDateIntoCurrentCurrency_ThenReturnString() {
        let stringDate = myCurrency.convertDateUpdate()
        XCTAssertEqual(stringDate, "Monday, 28 Mar 2022 21:49")
    }

    func testGivenReceiveListSymbol_WhenSortListSymbol_ThenIsFilterByOrderAlphabetic() {
        let firstElementInArray = myCurrency.sortListKey().first
        XCTAssertEqual(firstElementInArray, "AED")
    }

    func testGivenValueInMoney_WhenConvertMoneyToDollar_ThenMyValueAreConvertedInDollar() {
        let valuEuro = myCurrency.convertMoneyToDollar(fromSymbol: "EUR", value: 1)
        XCTAssertEqual(valuEuro, "1.097767")
    }
}
