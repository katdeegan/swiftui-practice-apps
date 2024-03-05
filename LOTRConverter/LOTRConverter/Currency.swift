//
//  Currency.swift
//  LOTRConverter
//
//  Created by Katherine Deegan on 3/5/24.
//

import SwiftUI

// Currency model
// CaseIterable -> provides collection of all values of Currency
// Identifiable --> conforms to "Identifiable", meaning each value for Currency if uniquely identifiable (requires "id" property)
enum Currency: Double, CaseIterable, Identifiable {
    // define .rawValue property for each (default for enum is the order it is defined in model; i.e. copperPenny.rawValue == 0.000
    case copperPenny = 6400
    case silverPenny = 64
    case silverPiece = 16
    case goldPenny = 4
    case goldPiece = 1 // base currency
    
    // id property to make Currency Identifiable - different options for what you can use for id property
    var id: Double { rawValue }
    // var id: Currency (self}
    
    // computed properties image + name - value is computed at the point of usage
    var image: ImageResource {
        switch self {
        case .copperPenny:
                .copperpenny
        case .silverPenny:
                .silverpenny
        case .silverPiece:
                .silverpiece
        case .goldPenny:
                .goldpenny
        case .goldPiece:
                .goldpiece
        }
    }
    
    var name: String {
        switch self {
        case .copperPenny:
            "Copper Penny"
        case .silverPenny:
            "Silver Penny"
        case .silverPiece:
            "Silver Piece"
        case .goldPenny:
            "Gold Penny"
        case .goldPiece:
            "Gold Piece"
        }
    }
    
    // declare model functions
    // func funcName(argument_label parameter_name: Type)
    func convert(_ amountString: String, to currency: Currency) -> String {
        // starting amount returns the amount in specified currency
        guard let doubleAmount = Double(amountString) // works if user only types numbers --> guard keyword is like try/catch block; protects from error (if user types letters / non-numbers)
        else {
            // leave other textfield blank
            return ""
        }
        
        let convertedAmount = (doubleAmount / self.rawValue) * currency.rawValue
        
        return String(format: "%.2f",convertedAmount)
    }
}
