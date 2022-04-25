//
//  TranslaterDTO.swift
//  Le Baluchon
//
//  Created by Yoan on 19/04/2022.
//

import Foundation

// MARK: - Translater
struct TranslaterDTO: Codable {
    let data: DataClass
}

// MARK: - array response translation
struct DataClass: Codable {
    let translations: [Translation]
}

// MARK: - Translation
struct Translation: Codable {
    let translatedText: String
}
