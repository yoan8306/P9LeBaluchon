//
//  translateLanguagesSupport.swift
//  Le Baluchon
//
//  Created by Yoan on 20/04/2022.
//

import Foundation

class TranslationManager {
    var listSupportLanguages: [Language]
    var firstLanguageSelected: String
    var secondLanguageSelected: String
    var inverseTranslate: Bool

    init() {
        firstLanguageSelected = "fr"
        secondLanguageSelected = "en"
        listSupportLanguages = []
        inverseTranslate = false
    }

    func inverseTranslation() {
        inverseTranslate = !inverseTranslate
    }
}
