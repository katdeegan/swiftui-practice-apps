//
//  ContentView.swift
//  LOTRConverter
//
//  Created by Katherine Deegan on 3/4/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            // background image
            Image(.background)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                // prancing pony image view
                Image(.prancingpony)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                // .scaledToFit() - width will change when you modify height to maintain scale
                
                // currency exchange text
                Text("Currency Exchange")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                
                // conversion section
                HStack {
                    // left conversion section
                    VStack {
                        // currency
                        HStack {
                            // currency image
                            Image(.silverpiece)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 33)
                            
                            // currency text
                            Text("Silver Piece")
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                        
                        // text field - user can type input
                        Text("TextField")
                    }
                    
                    // Equal sign
                    // method for accessing SF symbols (included with xcode)
                    // SF symbols can be treated as images / text (use both types of modifiers)
                    Image(systemName: "equal")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .symbolEffect(.pulse)
                    
                    // right conversion section
                    VStack {
                        // currency
                        HStack {
                            // currency text
                            Text("Gold Piece")
                                .font(.headline)
                                .foregroundStyle(.white)
                            
                            // currency image
                            Image(.goldpiece)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 33)
                        }
                        
                        // text field
                        Text("text field")
                    }
                }
                
                Spacer()
                
                // info button
                Image(systemName: "info.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
            }
            //.border(.blue)
            // testing that you put things in correct view by adding .border around view
        }
    }
}

#Preview {
    ContentView()
}
