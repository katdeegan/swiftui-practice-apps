//
//  ContentView.swift
//  ApexPredators
//
//  Created by Katherine Deegan on 3/6/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    let predators = Predators()
    @State var searchText = "" // making list searchable
    @State var alphabetical = false
    @State var currentSelection = PredatorType.all
    
    // computed property
    var filteredDinos: [ApexPredator] {
        predators.filter(by: currentSelection)
        predators.sort(by: alphabetical)
        return predators.search(for: searchText)
    }
    
    var body: some View {
        // tool bar comes with NavigationStack --> able to add button to tool bar via modifier
        // Assets -> AccentColor dictacts some of the default colors used throughout app (such as tool bar)
        NavigationStack {
            // view that contains root + other views
            // stack entire screens ontop of eachother. stack always displays most recent view that hasn't been removed. CANNOT remove root view (you can just cover it up)
            // List view - special ForEach loop with extra features (i.e. lazy loading, scrolling)
            // List is ROOT view in NavigationStack
            List(filteredDinos) {predator in
                NavigationLink {
                    // detail page for each dino
                    PredatorDetail(predator: predator, position: .camera(MapCamera(centerCoordinate: predator.location, distance: 30000)))
                } label: {
                    HStack {
                        // dino img
                        Image(predator.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .shadow(color: .white, radius: 1)
                        
                        VStack(alignment: .leading) {
                            // name
                            Text(predator.name)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            
                            // type
                            Text(predator.type.rawValue.capitalized)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.horizontal,13)
                                .padding(.vertical,5)
                                .background(predator.type.background)
                                .clipShape(.capsule)
                            
                        }
                    }
                }
                
            }
            .navigationTitle("Apex Predators") // titles go on each screen of NavigationStack
            .searchable(text: $searchText) // adds search bar
            .autocorrectionDisabled()
            .animation(.default, value: searchText) // animation to list changing as user searches
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // toggel alphabetical property between T/F when button is pressed
                        withAnimation{
                            alphabetical.toggle()
                        }
            
                    } label: {
                        // button appearnce changes based on alphabetical property
//                        if alphabetical {
//                            Image(systemName: "film")
//                        } else {
//                            Image(systemName: "textformat")
//                        }
                        
                        // Ternary operator to shorten conditional if statement
                        Image(systemName: alphabetical ? "film" : "textformat")
                            .symbolEffect(.bounce, value: alphabetical) // when alphabetical changes, bounch button
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        // kinda like a navigation link
                        // Picker view - some platforms (Mac, Watch, etc) wil show "Filter" title (not iOS mobile)
                        // add animation by adding modifier to selection property
                        Picker("Filter", selection: $currentSelection.animation()) {
                            ForEach(PredatorType.allCases) {
                                type in
                                Label(type.rawValue.capitalized, systemImage: type.icon)
                                
                            }
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
        
            }
        
        }
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ContentView()
}
