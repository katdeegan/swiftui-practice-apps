//
//  Stats.swift
//  Dex3
//
//  Created by Katherine Deegan on 3/12/24.
//

import SwiftUI
import Charts

struct Stats: View {
    @EnvironmentObject var pokemon: Pokemon
    
    var body: some View {
        Chart(pokemon.stats) { stat in
            // 6 stats -> 6 values in Chart
            
            // specify what kind of chart (mark)
            BarMark(x: .value("Value", stat.value), y: .value("Stat", stat.label)
            )
            .annotation(position: .trailing) {
                Text("\(stat.value)")
                    .padding(.top,-5)
                    .foregroundColor(.secondary) // charts have primary/secondary color properties
                    .font(.subheadline)
            }
  
        }
        .frame(height: 200)
        .padding([.leading, .bottom, .trailing])
        .foregroundColor(Color(pokemon.types![0].capitalized))
        .chartXScale(domain: 0...pokemon.highestStat.value+5)
    }
}

#Preview {
    Stats()
        .environmentObject(SamplePokemon.samplePokemon)
}
