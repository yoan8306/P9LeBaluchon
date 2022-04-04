//
//  SessionTaskTest.swift
//  Le BaluchonTests
//
//  Created by Yoan on 01/04/2022.
//

import XCTest
@testable import Le_Baluchon

class SessionTaskTest: XCTestCase {

    func testSuccessfulResponse() {
        // Setup object
        let session = URLSessionMock()
        let manager = SessionTask(session: session)

        // create data
        let response = FakeResponseMoneyRatesData()
        session.data = response.deviseCorrectData

        let url = URL(fileURLWithPath: "www.openclassrooms.fr")

        // perform request
        var result: Result<Data, Error>?
        manager.sendTask(url: url) { result = $0 }
        XCTAssertEqual(result, .success(response.deviseCorrectData))
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
