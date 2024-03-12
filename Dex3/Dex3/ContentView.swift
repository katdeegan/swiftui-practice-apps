//
//  ContentView.swift
//  Dex3
//
//  Created by Katherine Deegan on 3/10/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // FetchRequest to retrieve data, need to specify sort method because core data is stored in Graph structure
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default
    ) private var pokedex: FetchedResults<Pokemon>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        predicate: NSPredicate(format: "favorite = %d", true), // only fetch pokemon where favorite property is true
        animation: .default
    ) private var favorites: FetchedResults<Pokemon>
    
    @State var filterByFavorites = false
    
    // adding ViewModel so we can fetch real pokemon from API
    @StateObject private var pokemonVM = PokemonViewModel(controller: FetchController())
    
    var body: some View {
//        switch pokemonVM.status {
//        case .success:
            // NavigationView is deprecated --> being replaced by NavigationStack/
            NavigationStack {
                // List method implemented like this serves the same purpose as ForEach loop
                List(filterByFavorites ? favorites : pokedex) { pokemon in
                    NavigationLink(value: pokemon){
                        AsyncImage(url: pokemon.sprite) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                        // every attribute you create in Core Data is an OPTIONAL in Swift
                        Text((pokemon.name!.capitalized))
                        
                        if pokemon.favorite {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                }
                .navigationTitle("Pokedex")
                .navigationDestination(for: Pokemon.self, destination: { pokemon in
                    PokemonDetail()
                        .environmentObject(pokemon)
                })
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            withAnimation {
                                filterByFavorites.toggle()
                            }
                        } label: {
                            Label("Fiter by Favorites",
                                  systemImage: filterByFavorites ? "star.fill" : "star")
                            
                        }
                        .font(.title)
                        .foregroundColor(.yellow)
                        }
                    }
            }
//        default:
//            ProgressView()
//            //Text("Default")
//        }
        }
    }

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
