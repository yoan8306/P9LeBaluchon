//
//  MyCurrentCurrency.swift
//  Le Baluchon
//
//  Created by Yoan on 17/03/2022.
//

import Foundation

struct MyCurrentCurrency {
    let rates: [String: Float]
    let symbols: [String : String]
    let updatedDate: Date
    
     func convertDateUpdate(updatedDate: Date)-> String {
        let mydate = DateFormatter()
        mydate.dateFormat = "EE, d MMM yyyy HH:mm"
       return mydate.string(from: updatedDate)
    }
}
