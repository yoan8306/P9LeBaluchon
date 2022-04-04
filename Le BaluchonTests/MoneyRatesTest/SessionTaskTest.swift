//
//  SessionTaskTest.swift
//  Le BaluchonTests
//
//  Created by Yoan on 01/04/2022.
//

import XCTest
@testable import Le_Baluchon

class SessionTaskTest: XCTestCase {

    func testCallSymbolService_WhenDataIsCorrect_ThenResultEqualSuccess () {
        // Setup object
        let sessionTaskMock = SessionTaskMock()
        let moneyRatesService = MoneyRatesService(sessionTask: sessionTaskMock)

        // create data
        let response = FakeResponseMoneyRatesData()
        sessionTaskMock.data = response.symbolsCorrectData

        // perform request

        moneyRatesService.getSymbolsCurrency { result in
            switch result {
            case .success(let myCurrentCurrency):
                guard let symbolAED = myCurrentCurrency.symbols!["AED"] else {
                    return
                }
                XCTAssertEqual(symbolAED, "United Arab Emirates Dirham")
            case .failure:
                fatalError()
            }
        }
    }

//    func testGivenCallSymbolService_WhenNoDataReceive_ThenResultEqualFailure() {
//        let sessionTaskMock = SessionTaskMock()
//        let moneyRatesService = MoneyRatesService(sessionTask: sessionTaskMock)
//
//        moneyRatesService.getSymbolsCurrency { result in
//            switch result {
//            case .success:
//                fatalError()
//            case .failure(let error):
//                XCTAssertTrue(error.localizedDescription != nil)
//            }
//        }
//    }

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
                XCTAssertTrue(error.localizedDescription != nil)
            }
        }
    }

    func testGivenCallDeviseService_WhenCorrecteDataReceive_ThenResultEqualSuccess () {
        let sessionTaskMock = SessionTaskMock()
        let moneyRatesService = MoneyRatesService(sessionTask: sessionTaskMock)

        // create data
        let response = FakeResponseMoneyRatesData()
        sessionTaskMock.data = response.deviseCorrectData

        // perform request

        moneyRatesService.getDeviseCurrency { result in
            switch result {
            case .success(let myCurrentCurrency):
                guard let deviseRate = myCurrentCurrency.rates!["AED"] else {
                    return
                }
                XCTAssertEqual(deviseRate, 4.032079)
            case .failure:
                fatalError()
            }
        }
    }

//    func testGivenCallDevise_WhennoDataReceive_ThenResultEqualFailure() {
//        let sessionTaskMock = SessionTaskMock()
//        let moneyRatesService = MoneyRatesService(sessionTask: sessionTaskMock)
//
//        moneyRatesService.getDeviseCurrency { result in
//            switch result {
//            case .success:
//                fatalError()
//            case .failure(let error):
//                XCTAssertTrue(error.localizedDescription != nil)
//            }
//        }
//    }

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
                XCTAssertTrue(error.localizedDescription != nil)
            }
        }
    }
}
