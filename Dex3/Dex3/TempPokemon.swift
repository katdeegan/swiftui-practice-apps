//
//  TempPokemon.swift
//  Dex3
//
//  Created by Katherine Deegan on 3/11/24.
//

import Foundation

struct TempPokemon: Codable {
    // Temporary Pokemon model to help with transition from fetching data from online -> storing in our Core Data model
    // Codable - use model to decode data
    
    let id: Int
    let name: String
    let types: [String]
    
    // setting default values for stats because actual vale assignment is handled by a switch statement and you need to guarentee values will be set (when you set default you don't have to specify Int type, this is inferred by default)
    var hp = 0
    var attack = 0
    var defense = 0
    var specialAttack = 0
    var specialDefense = 0
    var speed = 0
    
    let sprite: URL
    let shiny: URL
    // fetched data doesn't have favorites property, so do not need to include it in temp model
    
    enum PokemonKeys: String, CodingKey {
        // help build json structure to match data we are fetching from api (some attributes are nested down multiple layers)
        // for enums, whatever is case is called is automatically set to "rawValue", unless you specify differently. i.e. case id --> rawValue = "id"
        
        // all cases correspond to top-level keys in api json
        case id
        case name
        case types
        case stats
        case sprites
        
        enum TypeDictionaryKeys: String, CodingKey {
            case type
            
            enum TypeKeys: String, CodingKey {
                case name
            }
        }
        
        enum StatDictionaryKeys: String, CodingKey {
            case value = "base_stat" // specify rawValue to be base_stat to match json key
            case stat
            
            enum StatKeys: String, CodingKey {
                case name
            }
        }
        
        enum SpriteKeys: String, CodingKey {
            case sprite = "front_default"
            case shiny = "front_shiny"
        }
    }
    
    init(from decoder: Decoder) throws {
        // keyedBy - PokemonKeys enum that build structure of nested JSON
        let container = try decoder.container(keyedBy: PokemonKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        
        // retrieving nested json properties
        // types
        var decodedTypes: [String] = []
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types) // typesContatiner contains multiple types
        while !typesContainer.isAtEnd {
            // while we are not at the end of the typesContainer
            let typesDictionaryContainer = try typesContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.self)
            let typeContainer = try typesDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.TypeKeys.self, forKey: .type)
            
            let type = try typeContainer.decode(String.self, forKey: .name)
            decodedTypes.append(type) // append type to types array
        }
        self.types = decodedTypes
        
        // stats
        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        while !statsContainer.isAtEnd {
            let statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.self)
            let statContainer = try statsDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.StatKeys.self, forKey: .stat)
            
            switch try statContainer.decode(String.self, forKey: .name) {
            case "hp":
                self.hp = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "attack":
                self.attack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "defense":
                self.defense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-attack":
                self.specialAttack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-defense":
                self.specialDefense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "speed":
                self.speed = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            default:
                print("It will never get here...")
            }
        }
        
    
        // sprites
        let spriteContainer = try container.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.self, forKey: .sprites)
        self.sprite = try spriteContainer.decode(URL.self, forKey: .sprite)
        self.shiny = try spriteContainer.decode(URL.self, forKey: .shiny)
    }
    
}
