//
//  CurrencyIcon.swift
//  LOTRConverter
//
//  Created by Katherine Deegan on 3/5/24.
//

import SwiftUI

struct CurrencyIcon: View {
    let currencyImage: ImageResource
    let currencyName: String
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(currencyImage)
                .resizable()
                .scaledToFit()
            
            Text(currencyName)
                .padding(3)
                .font(.caption)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .background(.brown.opacity(0.75))
            
            // .infinity - stretch to edges of parent view
            // order of modifiers matter - frame width BEFORE background (background only added to the modifiers that come before it)
        }
        .padding(3)
        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
        .background(.brown)
        .clipShape(.rect(cornerRadius: 25))
    }
}

#Preview(body: {
    CurrencyIcon(currencyImage: .goldpiece, currencyName: "Gold Piece")
})
