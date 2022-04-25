//
//  TranslateService.swift
//  Le Baluchon
//
//  Created by Yoan on 19/04/2022.
//

import Foundation

class TranslateService {
// MARK: - Properties
    static let shared = TranslateService(sessionTask: SessionTask.shared)
    var sessionTask: SessionTaskProtocol

// MARK: - life cycle
    init(sessionTask: SessionTaskProtocol) {
        self.sessionTask = sessionTask
    }

// MARK: - Functions
    func getTranslation(text: String?, langSource: String, langTarget: String,
                        completionHandler: @escaping (Result <TranslaterDTO, Error>) -> Void) {
        var urlTranslate = URLComponents()

        guard let text = text else {
            return
        }

        urlTranslate.scheme = "https"
        urlTranslate.host = "translation.googleapis.com"
        urlTranslate.path = "/language/translate/v2"
        urlTranslate.queryItems = [
        URLQueryItem(name: "q", value: text),
        URLQueryItem(name: "source", value: langSource),
        URLQueryItem(name: "target", value: langTarget),
        URLQueryItem(name: "key", value: ApiKeys.translateKey)
        ]

        guard let urlTranslate = urlTranslate.url else {
            return
        }

        sessionTask.sendTask(url: urlTranslate) { result in
            switch result {
            case .success(let data):
                guard let translatedText = try? JSONDecoder().decode(TranslaterDTO.self, from: data) else {
                    completionHandler(.failure(APIError.decoding))
                    return
                }
                completionHandler(.success(translatedText))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    func getSupportedLanguages(completionHandler: @escaping (Result <SupportedLanguagesDTO, Error>) -> Void) {
        var urlSupportedLanguages = URLComponents()

        urlSupportedLanguages.scheme = "https"
        urlSupportedLanguages.host = "translation.googleapis.com"
        urlSupportedLanguages.path = "/language/translate/v2/languages"
        urlSupportedLanguages.queryItems = [
        URLQueryItem(name: "target", value: "en"),
        URLQueryItem(name: "key", value: ApiKeys.translateKey)
        ]

        guard let urlSupportedLanguages = urlSupportedLanguages.url else {
            return
        }

        sessionTask.sendTask(url: urlSupportedLanguages) { result in
            switch  result {
            case .success(let data):
                guard let languagesList = try? JSONDecoder().decode(SupportedLanguagesDTO.self, from: data) else {
                    completionHandler(.failure(APIError.decoding))
                    return
                }
                completionHandler(.success(languagesList))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
