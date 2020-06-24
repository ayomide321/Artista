//
//  HelperFunctions.swift
//  Artista
//
//  Created by Ayomide Omolewa on 6/23/20.
//  Copyright © 2020 Ayomide Omolewa. All rights reserved.
//

import Foundation


func convertToCurrency(_ number: Double) -> String {
    
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    currencyFormatter.locale = Locale.current
    
    let priceString = currencyFormatter.string(from: NSNumber(value: number))!
    
    return priceString
    
}
