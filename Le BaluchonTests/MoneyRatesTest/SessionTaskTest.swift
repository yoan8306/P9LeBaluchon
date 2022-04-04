//
//  SessionTaskTest.swift
//  Le BaluchonTests
//
//  Created by Yoan on 01/04/2022.
//

import XCTest
@testable import Le_Baluchon

class SessionTaskTest: XCTestCase {

    var sessionTaskMock = SessionTaskMock()

    func testSuccessfulResponse() {
        // Setup object
        let moneyRatesService = MoneyRatesService(sessionTask: sessionTaskMock)

        // create data
        let response = FakeResponseMoneyRatesData()
        sessionTaskMock.data = response.symbolsCorrectData

        // perform request

        moneyRatesService.getSymbolsCurrency { result in
            switch result {
            case .success(let myCurrentCurrency):
                XCTAssertEqual(myCurrentCurrency.symbols["AED"], "United Arab Emirates Dirham")
            case .failure:
                fatalError()
            }
        }
    }
}
