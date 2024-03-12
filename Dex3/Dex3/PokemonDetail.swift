//
//  PokemonDetail.swift
//  Dex3
//
//  Created by Katherine Deegan on 3/12/24.
//

import SwiftUI
import CoreData

struct PokemonDetail: View {
    @Environment(\.managedObjectContext) private var viewContext
    // initializing Pokemon object when using Core Data
    @EnvironmentObject var pokemon: Pokemon
    @State var showShiny = false // toggle property to switch between shiny/sprite images
    
    var body: some View {
        ScrollView {
            ZStack {
                Image(pokemon.background)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .black, radius: 6)
                
                // for AsyncImage, you only need to add {} code if you want to modify image
                
                // if showShiny is true, use pokemon.shiny url, else use pokemon.sprite
                AsyncImage(url: showShiny ? pokemon.shiny : pokemon.sprite) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.top,50)
                } placeholder: {
                    ProgressView()
                }
            }
            
            HStack {
                ForEach(pokemon.types!, id: \.self) { type in
                    // type strings are unique id for loop
                    // add padding BEFORE background color so color is included in background (modifier applied in order)
                
                    Text(type.capitalized)
                        .font(.title2)
                        .shadow(color: .white, radius: 1)
                        .padding([.top,.bottom],7)
                        .padding([.leading,.trailing])
                        .background(Color(type.capitalized))
                        .cornerRadius(50)
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        pokemon.favorite.toggle()
                        // with Core Data NOTHING save unless you specify!!
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }
                    
                } label: {
                    if pokemon.favorite {
                        Image(systemName: "star.fill")
                    } else {
                        Image(systemName: "star")
                    }
                }
                .font(.largeTitle)
                .foregroundColor(.yellow)
                
            }
            .padding()
            
            Text("Stats")
                .font(.title)
                .padding(.bottom,-7)
            Stats()
                .environmentObject(pokemon)
        }
        .navigationTitle(pokemon.name!.capitalized) // NavigationStack is in ContentView
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showShiny.toggle()
                } label: {
                    if showShiny {
                        Image(systemName: "wand.and.stars")
                            .foregroundColor(.yellow)
                    } else {
                        Image(systemName: "wand.and.stars.inverse")
                    }
                    
                }
            }
        }
    }
}

#Preview {
    // need to specify you're returning PokemonDetail() view since there is other code in Preview
    // with EnvironmentObjects, add as modifier
    return PokemonDetail()
        .environmentObject(SamplePokemon.samplePokemon)
}
