//
//  Constants.swift
//  HPTrivia
//
//  Created by Katherine Deegan on 3/13/24.
//

import Foundation
import SwiftUI

enum Constants {
    static let hpFont = "PartyLetPlain"
    
    static let previewQuestion = try! JSONDecoder().decode([Question].self, from: Data(contentsOf: Bundle.main.url(forResource: "trivia", withExtension: "json")!))[0] // grab first question from trivia questions file
}

struct InfoBackgroundImage: View {
    var body: some View {
        Image("parchment")
            .resizable()
            .ignoresSafeArea()
            .background(.brown)
    }
}

extension Button {
    func doneButton() -> some View {
        self
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .tint(.brown)
            .buttonStyle(.borderedProminent)
    }
}

// from Paul Hudson
// shortens path directory (so we can save scores / book statuses to a file on local device (lighter than Core Data, since we don't need to save that much data)
extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
