//
//  SessionTaskTest.swift
//  Le BaluchonTests
//
//  Created by Yoan on 01/04/2022.
//

import XCTest
@testable import Le_Baluchon

class MoneyRatesServicesTest: XCTestCase {

    func testCallSymbolService_WhenDataIsCorrect_ThenResultEqualSuccess () {
        let sessionTaskMock = SessionTaskMock()
        let moneyRatesService = MoneyRatesService(sessionTask: sessionTaskMock)
        let response = FakeResponseMoneyRatesData()

        sessionTaskMock.data = response.symbolsCorrectData

        moneyRatesService.getSymbolsCurrency { result in
            switch result {
            case .success(let response):

                let symbols = try! XCTUnwrap(response.symbols)
                XCTAssertEqual(symbols["AED"], "United Arab Emirates Dirham")
            case .failure:
                fatalError()
            }
        }
    }

    func testGivenCallSymbolService_WhenDataIsIncorrect_ThenResultEqualFailure() {
        let sessionTaskMock = SessionTaskMock()
        let moneyRatesService = MoneyRatesService(sessionTask: sessionTaskMock)
        let response = FakeResponseMoneyRatesData()

        sessionTaskMock.data = response.moneyIncorrectData

        moneyRatesService.getSymbolsCurrency { result in
            switch result {
            case .success:
                fatalError()
            case .failure(let error):
                XCTAssertTrue(error.localizedDescription.isEmpty == false)
            }
        }
    }

    func testGivenCallDeviseService_WhenCorrecteDataReceive_ThenResultEqualSuccess() {
        let sessionTaskMock = SessionTaskMock()
        let moneyRatesService = MoneyRatesService(sessionTask: sessionTaskMock)
        let response = FakeResponseMoneyRatesData()
        
        sessionTaskMock.data = response.deviseCorrectData
        
        moneyRatesService.getDeviseCurrency { result in
            switch result {
            case .success(let myCurrentCurrency):
                guard let deviseRate = myCurrentCurrency.rates["AED"] else {
                    return
                }
                XCTAssertEqual(deviseRate, 4.032079)
            case .failure:
                fatalError()
            }
        }
    }

    func testGivenCallDeviseService_WhenIncorrecteDataReceive_ThenResultEqualFailure() {
        let sessionTaskMock = SessionTaskMock()
        let moneyRatesService = MoneyRatesService(sessionTask: sessionTaskMock)
        let response = FakeResponseMoneyRatesData()
        
        sessionTaskMock.data = response.moneyIncorrectData

        moneyRatesService.getDeviseCurrency { result in
            switch result {
            case .success:
                fatalError()
            case .failure(let error):
                XCTAssertTrue(error.localizedDescription.isEmpty == false)
            }
        }
    }
}
