//
//  FetchController.swift
//  Dex3
//
//  Created by Katherine Deegan on 3/11/24.
//

import Foundation
import CoreData

struct FetchController {
    // code for fetching Pokemon data
    
    enum NetworkError: Error {
        case badURL, badResponse, badData
    }
    
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
    
    // returns an Optional array of TempPokemon because you only want to return this IF pokemon need to be fetched from API / do not already exist in Core Data
    // returns [TempPokemon] or nil
    func fetchAllPokemon() async throws -> [TempPokemon]? {
        if havePokemon() {
            return nil
        }
        
        var allPokemon: [TempPokemon] = []
        
        var fetchComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)

        fetchComponents?.queryItems = [URLQueryItem(name: "limit", value: "386")]
        
        // guard - dont let code go past this part if it doens't work
        // check url
        guard let fetchURL = fetchComponents?.url else {
            throw NetworkError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        // check response
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        // check data
        // store JSON response in a dictionary
        // response is a dictionary. key "results" is the only part of the response dict we care about
        // "results" contains all pokemon + link to get their details (dict with name + url keys)
        guard let pokeDictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any], let pokedex = pokeDictionary["results"] as? [[String: String]] else {
            throw NetworkError.badData
        }
        
        for pokemon in pokedex {
            if let url = pokemon["url"] {
                allPokemon.append(try await fetchPokemon(from: URL(string: url)!))
            }
        }
        
        return allPokemon
    }
    
    private func fetchPokemon(from url: URL) async throws -> TempPokemon {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // check response / data
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        let tempPokemon = try JSONDecoder().decode(TempPokemon.self, from: data)
        
        print("Fetched \(tempPokemon.id): \(tempPokemon.name)")
        
        return tempPokemon
    }
    
    private func havePokemon() -> Bool{
        // check to see if we already have pokemon stored in database (if so, we do not need to fetchAllPokemon
        // before adding this check there would be an error in Simulator if you ran the app again on same device (bc pokemon was in core data but app was also trying to fetch and none of the fetched pokemon could be added to Core Data bc of the unique id constraint, so app was just hanging in "fetching" status and pokemon list view never loaded
        
        let context = PersistenceController.shared.container.newBackgroundContext() // check in background
        
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        
        // Predicate specifies exactly what you want to fetch
        // fetch the pokemon with an id of 1 and an id of 386 (first and last)
        fetchRequest.predicate = NSPredicate(format:"id IN %@", [1, 386])
        
        // run fetch request
        do {
            let checkPokemon = try context.fetch(fetchRequest)
            
            if checkPokemon.count == 2 {
                return true
            }
            
        } catch {
            print("Fetch failed: \(error)")
            return false
        }
        
        return false
    }
}
