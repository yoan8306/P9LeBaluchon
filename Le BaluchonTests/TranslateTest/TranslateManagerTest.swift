//
//  TranslateManagerTest.swift
//  Le BaluchonTests
//
//  Created by Yoan on 22/04/2022.
//

import Foundation
@testable import Le_Baluchon
import XCTest

class TranslateManagerTest: XCTestCase {

    func testGivenInverseTranslationEqualFalse_WhenCallFunctionInverse_ThenInverseTranslationEqualTrue() {
        let translationManger = TranslationManager()
        translationManger.inverseTranslate = false

        translationManger.inverseTranslation()

        XCTAssertTrue(translationManger.inverseTranslate)
    }

}
