//
//  SettingsView.swift
//  HPTrivia
//
//  Created by Katherine Deegan on 3/13/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: Store
    
    var body: some View {
        ZStack {
            InfoBackgroundImage()
            
            VStack {
                Text("Which books would you like to see questions from?")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                ScrollView {
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        // contains books in select/unselected states, as well as locked books (books locked behind in-app purchases)
                        ForEach(0..<7) { i in
                            
                            if store.books[i] == .active || (store.books[i] == .locked && store.purchasedIDs.contains("hp\(i+1)")) {
                                ZStack(alignment: .bottomTrailing) {
                                    // selected book
                                    Image("hp\(i+1)")
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                    
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .foregroundColor(.green)
                                        .shadow(radius: 1)
                                        .padding(3)
                                }
                                .onTapGesture {
                                    store.books[i] = .inactive
                                    store.saveStatus()
                                }
                                .task {
                                    // make sure every book with green checkmark is active
                                    store.books[i] = .active
                                    store.saveStatus()
                                }
                            } else if store.books[i] == .inactive {
                                ZStack(alignment: .bottomTrailing) {
                                    // unselected book
                                    Image("hp\(i+1)")
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                        .overlay(Rectangle().opacity(0.33)) // overlay to gray-out image a bit to indicate book is unselected
                                    
                                    Image(systemName: "circle")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .foregroundColor(.green.opacity(0.5))
                                        .shadow(radius: 1)
                                        .padding(3)
                                }
                                .onTapGesture {
                                    store.books[i] = .active
                                    store.saveStatus()
                                }

                                
                            } else {
                                
                                ZStack {
                                    // book locked behind in-app purchase
                                    Image("hp\(i+1)")
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                        .overlay(Rectangle().opacity(0.75))
                                    
                                    Image(systemName: "lock.fill")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .foregroundColor(.black)
                                        .shadow(color: .white.opacity(0.75), radius: 1)
                                        .padding(3)
                                }
                                .onTapGesture {
                                    // store.products = [hp4, hp5, hp6, hp7]
                                    let product = store.products[i-3]
                                    
                                    // async function must be inside Task
                                    Task {
                                        await
                                        store.purchase(product)
                                    }
                                }
                            }

                            
                        }
                                            
    
                    }
                    .padding()
                    
                }
                
                Button("Done") {
                    dismiss()
                }
                .doneButton()
            }
            .foregroundColor(.black)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(Store())
}
