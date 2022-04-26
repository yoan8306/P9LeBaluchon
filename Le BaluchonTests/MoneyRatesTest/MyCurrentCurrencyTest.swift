//
//  MoneyRatesServiesTestCase.swift
//  Le BaluchonTests
//
//  Created by Yoan on 28/03/2022.
//

import XCTest
@testable import Le_Baluchon

class MyCurrentCurrencyTest: XCTestCase {
// MARK: - Properties
    let data = FakeResponseMoneyRatesData()
    var listSymbols: SymbolsDTO {
        try! XCTUnwrap(try JSONDecoder().decode(SymbolsDTO.self, from: data.symbolsCorrectData))
    }
    var listDevise: DeviseDTO {
        try! XCTUnwrap(try JSONDecoder().decode(DeviseDTO.self, from: data.deviseCorrectData))
    }
    var myCurrency = MyCurrentCurrency()

// MARK: - Life cycle
    override func setUp() {
        super.setUp()
        myCurrency = MyCurrentCurrency(devise: listDevise, symbols: listSymbols.symbols!)
    }

// MARK: - Test
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
