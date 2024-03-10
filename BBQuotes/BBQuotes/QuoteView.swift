//
//  QuoteView.swift
//  BBQuotes
//
//  Created by Katherine Deegan on 3/8/24.
//

import SwiftUI

struct QuoteView: View {
    @StateObject private var viewModel = ViewModel(controller: FetchController())
    
    @State private var showCharInfo = false
    
    let show: String
    
    var body: some View {
        // GeometryReader - uses the view you're in (now that you can run SwiftUI on Mac, run multiple apps at once, etc)
        GeometryReader { geo in
            ZStack {
                // converts Show Name to showname (corresponds to name of correct background image)
                //Image(show.lowercased().filter{ $0 != " "})
                Image(show.lowerNoSpaces)
                    .resizable()
                    .frame(width: geo.size.width * 2.7, height: geo.size.height*1.2)
                
                // adding another container around everything before button so button doesn't jump around on screen with different quote/image sizes
                
                VStack {
                
                    VStack {
                        Spacer(minLength: 80)
                        switch viewModel.status {
                        case .success(let data):
                            
                            Text("\"\(data.quote.quote)\"")
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()
                                .background(.black.opacity(0.5))
                                .cornerRadius(25)
                                .padding(.horizontal)
                            ZStack(alignment: .bottom) {
                                //Image("jessepinkman")
                                AsyncImage(url: data.character.images[0]) { image in
                                    image // need to do this to add modifiers to AsyncImage
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: geo.size.width/1.1, height: geo.size.height/1.8)
                                .onTapGesture {
                                    showCharInfo.toggle()
                                }
                                .sheet(isPresented: $showCharInfo) {
                                    CharacterView(show: show, character: data.character)
                                }
                                
                                Text(data.quote.character)
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                    .background(.ultraThinMaterial)
                            }
                            .frame(width: geo.size.width/1.1, height: geo.size.height/1.8)
                            .cornerRadius(80)
                            
                        case .fetching:
                            ProgressView()
                            
                        default:
                            EmptyView()
                        }
                        
                        
                        Spacer()
                    }
                    
                    Button(action: {
                        Task {
                            // Task - run async functions in synchronous area
                            await viewModel.getData(for: show)
                        }
                    },
                           label: {
                        Text("Get Random Quote")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .padding(7)
                            .foregroundColor(.white)
                            .background(Color("\(show.noSpaces)Button"))

                            .cornerRadius(7)
                            .shadow(color: Color("\(show.noSpaces)Shadow"), radius: 2)
                    })
                    
                    Spacer(minLength: 180)
                    
                }
                .frame(width: geo.size.width)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        //.ignoresSafeArea()
    }
}

#Preview {
    QuoteView(show: Constants.bcsName)
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
