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

    func testGivenReverseTranslationEqualFalse_WhenCallFunctionReverse_ThenReverseTranslationEqualTrue() {
        let translationManger = TranslationManager()
        translationManger.reverseTranslate = false

        translationManger.reverseTranslation()

        XCTAssertTrue(translationManger.reverseTranslate)
    }

}
