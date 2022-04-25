//
//  SupportedLanguagesDTO.swift
//  Le Baluchon
//
//  Created by Yoan on 19/04/2022.
//

import Foundation

// les marks ne sont pas en rapport avec les structures

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
