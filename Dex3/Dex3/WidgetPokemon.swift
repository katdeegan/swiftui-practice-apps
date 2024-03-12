//
//  WidgetPokemon.swift
//  Dex3
//
//  Created by Katherine Deegan on 3/12/24.
//

import SwiftUI

enum WidgetSize {
    // model for widget size
    // designing 3 widgets for small, med, large iphone widget options
    case small, medium, large
}

struct WidgetPokemon: View {
    @EnvironmentObject var pokemon: Pokemon
    let widgetSize: WidgetSize
    
    var body: some View {
        ZStack {
            Color(pokemon.types![0].capitalized)
            
            // different based on widget sixe
            switch widgetSize {
            case .small:
                FetchedImage(url: pokemon.sprite)
            case .medium:
                // medium widget is kind of horizontal
                HStack {
                    FetchedImage(url: pokemon.sprite)
                    
                    VStack(alignment: .leading, content: {
                        Text(pokemon.name!.capitalized)
                            .font(.title)
                        
                        Text(pokemon.types!.joined(separator: ", ").capitalized)
                    })
                    .padding(.trailing, 30)
                }
            case .large:
                FetchedImage(url: pokemon.sprite)
                
                VStack {
                    HStack {
                        Text(pokemon.name!.capitalized)
                            .font(.largeTitle)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Text(pokemon.types!.joined(separator: ", ").capitalized)
                            .font(.title2)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    WidgetPokemon(widgetSize: .large)
        .environmentObject(SamplePokemon.samplePokemon)
}
