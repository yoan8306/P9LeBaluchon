//
//  translateLanguagesSupport.swift
//  Le Baluchon
//
//  Created by Yoan on 20/04/2022.
//

import Foundation

class TranslationManager {
    var listSupportLanguages: [Language] = []
    // language au lieu de 'lang' 
    var firstLangSelected = "fr"
    var secondLangSelected = "en"
    var reverseTranslate = false

    func reverseTranslation() {
    reverseTranslate = !reverseTranslate
    }
}
