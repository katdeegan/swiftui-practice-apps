//
//  SelectCurrency.swift
//  LOTRConverter
//
//  Created by Katherine Deegan on 3/5/24.
//

import SwiftUI

struct SelectCurrency: View {
    @Environment(\.dismiss) var dismiss
    
    // Binding properties
    @Binding var topCurrency: Currency
    @Binding var bottomCurrency: Currency
    
    var body: some View {
        ZStack {
            // background
            Image(.parchment)
                .resizable()
                .ignoresSafeArea()
                .background(.brown)
            
            VStack {
                // text
                Text("Select the currency you are starting with:")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                // currency icons
                // LazyVGrid - items aligned vertically, "Lazy" means it only loads items as you need them (i.e. if you have a stack with 1000s of views that you'd scroll between)
                
                CurrencyLazyVGrid(selectedCurrency: $topCurrency)
                
                
                
                // text
                Text("Select the currency you are starting with:")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                // currency icons
                CurrencyLazyVGrid(selectedCurrency: $bottomCurrency)
                
                // Done button
                Button("Done") {
                    // button action code
                    dismiss()
                    print("dismiss env property \(dismiss)")
                }
                .buttonStyle(.borderedProminent)
                .tint(.brown)
                .font(.largeTitle)
                .padding()
                .foregroundStyle(.white)
            }
            .padding()
            .multilineTextAlignment(.center)
        }
        .foregroundStyle(.black)
    }
}

#Preview {
    SelectCurrency(topCurrency: .constant(.copperPenny), bottomCurrency: .constant(.goldPenny))
}

