//
//  PokemonExt.swift
//  Dex3
//
//  Created by Katherine Deegan on 3/12/24.
//

import Foundation

extension Pokemon {
    // extension for Dex3 Pokemon model
    // useful when you want to extend your model to include things that may be hard to include in Core Data
    
    // background image for pokemon Detail view
    var background: String {
        // pokemon may have more than one type - grab the first element of the type array
        switch self.types![0] {
        case "normal", "grass", "electric", "poison", "fairy":
                return "normalgrasselectricpoisonfairy"
        case "rock", "ground", "steel", "fighting", "ghost", "dark", "psychic":
            return "rockgroundsteelfightingghostdarkpsychic"
        case "fire", "dragon":
            return "firedragon"
        case "flying", "bug":
            return "flyingbug"
        case "ice":
            return "ice"
        case "water":
            return "water"
        default:
            return "notGoingToHappen"
        }
    }
    
    // in view we want attributes to be in a specific order
    // in view we wamt to be able to see attribute name (not just attribute value)
    
    var stats: [Stat] {
        [
            Stat(id: 1, label: "HP", value: self.hp),
            Stat(id: 2, label: "Attack", value: self.attack),
            Stat(id: 3, label: "Defense", value: self.defense),
            Stat(id: 4, label: "Special Attack", value: self.specialAttack),
            Stat(id: 5, label: "Special Defense", value: self.specialDefense),
            Stat(id: 6, label: "Speed", value: self.speed)
            
        ]
    }
        
    var highestStat: Stat {
        stats.max { $0.value < $1.value }!
    }
    
    func organizeTypes() {
        if self.types!.count == 2 && self.types![0] == "normal" {
            // if one type is normal, swap the types so normal appears second
            self.types!.swapAt(0, 1)
            // .swapAt() implements the following logic:
            /*
            let tempType = self.types![0]
            self.types![0] = self.types![1]
            self.types![1] = tempType
             */
        }
        
    }
    
}

struct Stat: Identifiable {
    let id: Int
    let label: String
    let value: Int16
}
