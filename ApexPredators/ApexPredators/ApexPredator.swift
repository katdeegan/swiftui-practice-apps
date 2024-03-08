//
//  ApexPredator.swift
//  ApexPredators
//
//  Created by Katherine Deegan on 3/6/24.
//

import Foundation
import SwiftUI
import MapKit

// ApexPredator model

struct ApexPredator: Decodable, Identifiable {
    // building model based on jpapexpredators json 
    // Decodable protocol - decode json data to Swift model; all property-types need to conform to Decodable
    let id: Int
    let name: String
    let type: PredatorType
    let latitude: Double
    let longitude: Double
    let movies: [String]
    let movie_scenes: [MovieScenes]
    let link: String
    
    var image: String {
        name.lowercased().replacingOccurrences(of: " ", with: "") // all dino images are identified by the all-lowercase name with spaces removed
    }
    
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    struct MovieScenes: Decodable, Identifiable {
        let id: Int
        let movie: String
        let scene_description: String
    }
    
}

enum PredatorType: String, Decodable, CaseIterable, Identifiable {
    var id: PredatorType {
        self
    }
    
    case all
    case land
    case air
    case sea
    
    var background: Color {
        switch self {
        case .land:
                .brown
        case .air:
                .teal
        case .sea:
                .blue
        case .all:
                .white // doesn't matter - "all" is not an actual predator type here
        }
    }
    
    var icon: String {
        switch self {
        case .all:
            "square.stack.3d.up.fill"
        case .land:
            "leaf.fill"
        case .air:
            "wind"
        case .sea:
            "drop.fill"
        }
    }
}
