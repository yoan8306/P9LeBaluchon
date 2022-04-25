//
//  TranslaterDTO.swift
//  Le Baluchon
//
//  Created by Yoan on 19/04/2022.
//

import Foundation

// les marks ne sont pas en rapport avec les structures
// DataClass c'est pas très parlant, utilise un nom qui représente mieux ce qu'il représente

// MARK: - Welcome
struct TranslaterDTO: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let translations: [Translation]
}

// MARK: - Translation
struct Translation: Codable {
    let translatedText: String
}
