//
//  CurrencyLazyVGrid.swift
//  LOTRConverter
//
//  Created by Katherine Deegan on 3/5/24.
//

import SwiftUI

struct CurrencyLazyVGrid: View {
    @Binding var selectedCurrency: Currency
    
    var body: some View {
        LazyVGrid(columns: [GridItem(), GridItem(), GridItem()], content: {
            // ForEach loop - container View, builds a View specified number of times
            // range argument - 0..<5 --> range 0,1,2,3,4
            // iterable / collection argument - Currency.allCases
            
            ForEach(Currency.allCases){ currency in
                if self.selectedCurrency == currency {
                    // conditional to modify appearance of selected currency
                    CurrencyIcon(
                        currencyImage: currency.image,
                        currencyName: currency.name)
                    .shadow(color: .black, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    .overlay {
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .stroke(lineWidth: 3)
                            .opacity(0.5)
                    }
                } else {
                    CurrencyIcon(
                        currencyImage: currency.image,
                        currencyName: currency.name)
                    .onTapGesture {
                        self.selectedCurrency = currency
                        print("Selected currency: \(selectedCurrency)")
                    }
                }
            }
        })
    }
}

#Preview(body: {
    CurrencyLazyVGrid(selectedCurrency: .constant(.silverPenny))
})
