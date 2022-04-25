//
//  FakeResponseTranslateData.swift
//  Le BaluchonTests
//
//  Created by Yoan on 22/04/2022.
//

import Foundation

class FakeResponseTranslateData {

    // non utilisé `responseOK` `responseFailed`
    // MARK: - Response
    let responseOK = HTTPURLResponse(url: URL(string: "https://duckduckgo.com")!,
                                     statusCode: 200,
                                     httpVersion: nil,
                                     headerFields: nil)
    let responseFailed = HTTPURLResponse(url: URL(string: "https://duckduckgo.com")!,
                                         statusCode: 500,
                                         httpVersion: nil,
                                         headerFields: nil)
    // MARK: - Error
    class TranslateError: Error {}
    let weatherError = TranslateError()

    // MARK: - Data
// swiftlint:disable force_try
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
