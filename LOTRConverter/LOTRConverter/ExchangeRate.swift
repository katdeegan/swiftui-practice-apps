//
//  ExchangeRate.swift
//  LOTRConverter
//
//  Created by Katherine Deegan on 3/4/24.
//

import SwiftUI

struct ExchangeRate: View {
    // don't need to wrap properties with @State because they don't change with given instance of ExchangeRate
    
    let leftImage: ImageResource
    let text: String
    let rightImage: ImageResource
    
    var body: some View {
        HStack{
            // left currency image
            Image(leftImage)
                .resizable()
                .scaledToFit()
                .frame(height: 33)
            
            // exchange rate text
            Text(text)
            
            // right currency image
            Image(rightImage)
                .resizable()
                .scaledToFit()
                .frame(height: 33)
        }
    }
}

#Preview(body: {
    ExchangeRate(leftImage: .goldpiece, text: "1 Gold Piece = 4 Gold Pennies", rightImage: .goldpenny)
})

