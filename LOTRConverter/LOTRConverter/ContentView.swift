//
//  ContentView.swift
//  LOTRConverter
//
//  Created by Katherine Deegan on 3/4/24.
//

import SwiftUI
import TipKit

struct ContentView: View {
    // create STORED property showExchangeInfo
    // @State - allows property to change state of view
    @State var showExchangeInfo = false
    @State var showSelectCurrency = false
    @State var leftAmount = ""
    @State var rightAmount = ""
    
    // "master" currency properties, need to bind currency proeprties in SelectCurrency / CurrencyIcon view to this property
    @State var leftCurrency: Currency = .silverPiece
    @State var rightCurrency: Currency = .goldPiece
    
    // boolean property - allows us to track where on screen we're currently focused
    // which text field are we focusing on? this text field should be the one that is controlling the value of the other textfield
    @FocusState var leftTyping
    @FocusState var rightTyping
    
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
                            Image(leftCurrency.image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 33)
                            
                            // currency text
                            Text(leftCurrency.name)
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                        .padding(.bottom,-5)
                        .onTapGesture {
                            showSelectCurrency.toggle()
                        }
                        .popoverTip(CurrencyTip(), arrowEdge: .bottom)
                        
                        // text field - user can type input
                        TextField("Amount", text: $leftAmount)
                            .textFieldStyle(.roundedBorder)
                            .focused($leftTyping)
                            .keyboardType(.decimalPad)
                            .onChange(of: leftAmount) {
                                if leftTyping {
                                    rightAmount = leftCurrency.convert(leftAmount, to: rightCurrency)
                                }
                            } // if .focused(true), then exceute .onChange and update rightAmount
                        
                        //Binding<String> - user can change property + code can change property, indicate with $ prefix
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
                            Text(rightCurrency.name)
                                .font(.headline)
                                .foregroundStyle(.white)
                            
                            // currency image
                            Image(rightCurrency.image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 33)
                        }
                        .padding(.bottom,-5)
                        .onTapGesture {
                            showSelectCurrency.toggle()
                        }
                        
                        // negative padding to make things closer
                        
                        // text field
                        TextField("Amount", text: $rightAmount)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.trailing)
                            .focused($rightTyping)
                            .keyboardType(.decimalPad)
                            .onChange(of: rightAmount) {
                                if rightTyping {
                                    leftAmount = rightCurrency.convert(rightAmount, to: leftCurrency)
                                }
                            } // .onChange modifier can actually be added to entire ContentView (is not specifically associated with TextField)
                    
                    }
                }
                .padding() // pushes currency conversion section inwards
                .background(.black.opacity(0.5))
                .clipShape(.capsule)
                
                Spacer()
                
                // info button
                HStack {
                    Spacer()
                    Button {
                        showExchangeInfo.toggle()
                        // ex print statement with string to debug in console
                        //print("showExchangeInfo value: \(showExchangeInfo)")
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                    }
                    .padding(.trailing)
                }
                //.border(.blue)
                // testing that you put things in correct view by adding .border around view
            }
            .task {
                // allows us to run code in background when view appears
                // run code to configure tipkit
                try? Tips.configure()
            }
            .onChange(of: leftCurrency){
                leftAmount = rightCurrency.convert(rightAmount, to: leftCurrency)
            }
            .onChange(of: rightCurrency){
                rightAmount = leftCurrency.convert(leftAmount, to: rightCurrency)
            }
            .sheet(isPresented: $showExchangeInfo, content: {
                // view we want to present
                ExchangeInfo()
            }) // sheet modifier can be added to any view (it has nothing to do with button, just watching showExchangeInfo property
            .sheet(isPresented: $showSelectCurrency, content: {
                SelectCurrency(topCurrency: $leftCurrency, bottomCurrency: $rightCurrency)
            })
        }
    }
}

#Preview {
    ContentView()
}
