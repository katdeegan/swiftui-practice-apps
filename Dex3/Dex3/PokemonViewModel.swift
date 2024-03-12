//
//  PokemonViewModel.swift
//  Dex3
//
//  Created by Katherine Deegan on 3/11/24.
//

import Foundation

@MainActor // runs on main thread
class PokemonViewModel: ObservableObject {
    // code for getting data ready for out app
    
    enum Status {
        case notStarted
        case fetching
        case success
        case failed(error: Error)
    }
    
    @Published private(set) var status = Status.notStarted
    
    private let controller: FetchController
    
    init(controller: FetchController) {
        self.controller = controller
        
        Task {
            // getPokemon function should run automatically as soon as app is launched
            // can only run an async function in init() when it is in a Task{}
            await getPokemon()
        }
    }
    
    private func getPokemon() async {
        status = .fetching
        
        do {
            // try await bc you're calling an async/throws function
            // pokedex will be [TempPokemon] IF Pokemon do not exist in Core Data (i.e. if fetchAllPokemon() returns nil)
            
            // guard keyword checks if an Optional exists (is not nil) and executes the following code onlt if it DOES EXIST
            // specify behavior when Optional is nil with else {}
            guard var pokedex = try await controller.fetchAllPokemon() else {
                print("Pokemon have already been saved to Core Data.")
                status = .success
                return // end function
            }
            
            print("All Pokemon have been fetched. Status code: \(status)")
            
            // sort pokemon (bc fetchAllPokemon is async, pokemon might not be fetched in correct order)
            pokedex.sort { $0.id < $1.id }// sort from lowest -> highest by id
            
            print("All Pokemon have been sorted. Status code: \(status)")
            
            for pokemon in pokedex {
                print("Pokemon \(pokemon.id) being added to Core Data. Status code: \(status)")
                // add pokemon to Core Data
                let newPokemon = Pokemon(context: PersistenceController.shared.container.viewContext) // accessing where you want to store new data
                newPokemon.id = Int16(pokemon.id) // wrap in Int16() bc id attribute in core data is type Int16
                newPokemon.name = pokemon.name
                newPokemon.types = pokemon.types
                newPokemon.organizeTypes() // order types
                newPokemon.hp = Int16(pokemon.hp)
                newPokemon.attack = Int16(pokemon.attack)
                newPokemon.defense = Int16(pokemon.defense)
                newPokemon.specialAttack = Int16(pokemon.specialAttack)
                newPokemon.specialDefense = Int16(pokemon.specialDefense)
                newPokemon.speed = Int16(pokemon.speed)
                newPokemon.sprite = pokemon.sprite
                newPokemon.shiny = pokemon.shiny
                newPokemon.favorite = false
                
                // try and save changes to data store (for persistence)
                try PersistenceController.shared.container.viewContext.save()
                print("Pokemon \(pokemon.id) has been saved to Core Data. Status code: \(status)")
            }
            
            status = .success // status property serve to alert the View so it can update based on changes
            print("All Pokemon have been added to Core Data. Status code: \(status)")
            

        } catch {
            status = .failed(error: error)
        }
    }
    
}
