//
//  FetchedImage.swift
//  Dex3
//
//  Created by Katherine Deegan on 3/12/24.
//

import SwiftUI

struct FetchedImage: View {
    let url: URL? // urls are Optional be default
    
    var body: some View {
        // retrieve image online and make it so you can use it as Home Screen widget
        
        // unwrap url
        // if url exists (not nil) ... set imageData to contentsOf url
        // chaining if let statements - doesn't move on unless the previous statement works
        if let url, let imageData = try? Data(contentsOf: url), let uiImage = UIImage(data: imageData) {
            // if all of these work..
            Image(uiImage: uiImage) // uiImage works best when you're creating an image from data
                .resizable()
                .scaledToFit()
                .shadow(color: .black, radius: 6)
        } else {
            // if any of 3 conditions specified in get let go wrong, this code gets executed
            Image("bulbasaur")
        }
    }
}

#Preview {
    FetchedImage(url: SamplePokemon.samplePokemon.sprite)
}
