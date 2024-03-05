//
//  CurrencyTip.swift
//  LOTRConverter
//
//  Created by Katherine Deegan on 3/5/24.
//

import Foundation
import TipKit

struct CurrencyTip: Tip {
    var title = Text("Change Currency")
    var message: Text? = Text("You can select the currencies by tapping on the left or right currency icon.")// optionals automatically set to nil unless specified
    
    
}
