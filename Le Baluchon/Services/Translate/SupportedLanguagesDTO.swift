//
//  SupportedLanguagesDTO.swift
//  Le Baluchon
//
//  Created by Yoan on 19/04/2022.
//

import Foundation

// MARK: - Welcome
struct SupportedLanguagesDTO: Codable {
    let data: ListLanguages
}

// MARK: - DataClass
struct ListLanguages: Codable {
    let languages: [Language]
}

// MARK: - Language
struct Language: Codable {
    let language, name: String
}
