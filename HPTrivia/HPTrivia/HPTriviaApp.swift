//
//  HPTriviaApp.swift
//  HPTrivia
//
//  Created by Katherine Deegan on 3/13/24.
//

import SwiftUI

@main
struct HPTriviaApp: App {
    @StateObject private var store = Store()
    @StateObject private var game = Game()
    
    var body: some Scene {
        WindowGroup {
            // makes ContentView appear first when app starts
            ContentView()
                .environmentObject(store)
                .environmentObject(game)
                .task {
                    await store.loadProducts()
                    game.loadScores()
                    store.loadStatus()
                }
        }
    }
}
