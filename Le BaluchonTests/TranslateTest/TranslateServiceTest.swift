//
//  TranslateServiceTest.swift
//  Le BaluchonTests
//
//  Created by Yoan on 22/04/2022.
//

import Foundation
@testable import Le_Baluchon
import XCTest

class TranslateServiceTest: XCTestCase {
    func testGivenCallListSupportLang_WhenDataIsCorrect_ThenGetListLangSupport() {
        let sessionTaskMock = SessionTaskMock()
        let translateService = TranslateService(sessionTask: sessionTaskMock)
        let response = FakeResponseTranslateData()

        sessionTaskMock.data = response.listSupportLang

        translateService.getSupportedLanguages { result in
            switch result {
            case .success(let response):

                let symbols = try! XCTUnwrap(response.data.languages)
                XCTAssertEqual(symbols[1].name, "Albanian")
            case .failure:
                fatalError()
            }
        }
    }

    func testGivenCallListSupportLang_WhenDataIsIncorrect_ThenReturnFailure() {
        let sessionTaskMock = SessionTaskMock()
        let translateService = TranslateService(sessionTask: sessionTaskMock)
        let response = FakeResponseTranslateData()

        sessionTaskMock.data = response.translateIncorrectData

        translateService.getSupportedLanguages { result in
            switch result {
            case .success:
                fatalError()
            case .failure(let error):
                XCTAssertTrue(error.localizedDescription.isEmpty == false)
            }
        }
    }

    func testGivenCallTranslationService_WhenDataIsCorrect_ThenReturnTranslation() {
        let sessionTaskMock = SessionTaskMock()
        let translateService = TranslateService(sessionTask: sessionTaskMock)
        let response = FakeResponseTranslateData()

        sessionTaskMock.data = response.translateCorrectData
        let textSource = "Bonjour, comment ça va?"

        translateService.getTranslation(text: textSource, langSource: "fr", langTarget: "en") { result in
            switch result {
            case .success(let response):

                let translation = try! XCTUnwrap(response.data.translations.first?.translatedText)
                XCTAssertEqual(translation, "Hello how are you?")
            case .failure:
                fatalError()
            }
        }
    }

    func testGivenCallTranslateService_WhenDataIsIncorrect_ThenReturnFailure() {
        let sessionTaskMock = SessionTaskMock()
        let translateService = TranslateService(sessionTask: sessionTaskMock)
        let response = FakeResponseTranslateData()

        sessionTaskMock.data = response.translateIncorrectData

        translateService.getTranslation(text: "", langSource: "", langTarget: "") { result in
            switch result {
            case .success:
                fatalError()
            case .failure(let error):
                XCTAssertTrue(error.localizedDescription.isEmpty == false)
            }
        }
    }
}
