//
//  FakeResponseTranslateData.swift
//  Le BaluchonTests
//
//  Created by Yoan on 22/04/2022.
//

import Foundation

class FakeResponseTranslateData {
    // MARK: - Error
    class TranslateError: Error {}
    let weatherError = TranslateError()

    // MARK: - Data
    var listSupportLang: Data {
        let bundle = Bundle(for: FakeResponseTranslateData.self)
        let url = bundle.url(forResource: "LangSupportedList", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }

    var translateCorrectData: Data {
        let bundle = Bundle(for: FakeResponseTranslateData.self)
        let url = bundle.url(forResource: "Translate", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    var translateIncorrectData = "i'm bad json".data(using: .utf8)
}
