//
//  Predators.swift
//  ApexPredators
//
//  Created by Katherine Deegan on 3/6/24.
//

import Foundation

class Predators {
    // "Manipulation" layer --> convert raw json to usable format
    
    // where we will store all decoded ApexPredators
    var allApexPredators: [ApexPredator] = []
    var apexPredators: [ApexPredator] = []
    
    // function that runs automatically when new instance of Predators is created
    init() {
        decodeApexPredatorData()
    }
    
    func decodeApexPredatorData() {
        if let url = Bundle.main.url(forResource: "jpapexpredators", withExtension: "json") {
            do {
                // try to decode data
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                allApexPredators = try decoder.decode([ApexPredator].self, from: data)
                apexPredators = allApexPredators
            } catch {
                // catches error if decoding fails
                print("Error decoding JSON data: \(error)")
            }
        } // if let creates new property url ONLY if Bundle.main.url() exists
    }
    
    func search(for searchTerm: String) -> [ApexPredator] {
        // argLabel + parameterName -> sound like natural english
        // data manipulation (i.e. searching) should be done here, in "manipulation" layer
        if searchTerm.isEmpty {
            return apexPredators
        } else {
            // filter collection
            return apexPredators.filter { predator in
                predator.name.localizedCaseInsensitiveContains(searchTerm)
            }
        }

        
    }
    
    func sort(by alphabetical: Bool) {
        // default sort is by movie appearance, option to sort alphabetically
        // .sort --> function that comes with Collections, requires 2 properties to compare
        // sort is in-place
        apexPredators.sort {predator1, predator2 in
            if alphabetical {
                // a,b,c are lowest, x,y,z are highest
                predator1.name < predator2.name
            } else {
                predator1.id < predator2.id
            }
        }
    }
    
    func filter(by type: PredatorType) {
        // NOT in-place --> creates a temp list (compares each element to filter criteria, then adds element to temp list if it matches condition)
        if type == .all {
            // no need to filter when "all" is selected
            apexPredators = allApexPredators
        } else {
            apexPredators = allApexPredators.filter { predator in
                predator.type == type
            }
        }
    }
    
}
