//
//  translateLanguagesSupport.swift
//  Le Baluchon
//
//  Created by Yoan on 20/04/2022.
//

import Foundation

class TranslateLanguagesSupport {
    var listSupportLanguages: [Language] = []

    func getSelectedLanguages(selected: Language) -> String {
        selected.language
    }

}
