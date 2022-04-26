//
//  translateLanguagesSupport.swift
//  Le Baluchon
//
//  Created by Yoan on 20/04/2022.
//

import Foundation


class TranslationManager {
    var listSupportLanguages: [Language] = []
    var firstLanguageSelected = "fr"
    var secondLanguageSelected = "en"
    var inverseTranslate = false

    func inverseTranslation() {
    inverseTranslate = !inverseTranslate
    }
}
