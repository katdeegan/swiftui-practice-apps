//
//  SamplePokemon.swift
//  Dex3
//
//  Created by Katherine Deegan on 3/12/24.
//

import Foundation
import CoreData

struct SamplePokemon {
    // shared code to display sample pokemom in Preview
    
    // let samplePokemon be shared throughout the app so we're always accessing the same one (use in any Preview)
    static let samplePokemon = {
        let context = PersistenceController.preview.container.viewContext
        
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        // Retrieving samplePokemon from PersistenceController
        let results = try! context.fetch(fetchRequest)  // returns array of Pokemon
        
        return results.first!
        
    } ()
}
