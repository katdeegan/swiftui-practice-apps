//
//  ContentView.swift
//  BBQuotes
//
//  Created by Katherine Deegan on 3/8/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // each view is its own screen / tab
            QuoteView(show: Constants.bbName)
                .tabItem {
                    Label("Breaking Bad", systemImage: "tortoise")
                }
            
            QuoteView(show: Constants.bcsName)
                .tabItem {
                    Label("Better Call Saul", systemImage: "briefcase")
                }
        }
        .onAppear{
            UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance()
        }
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ContentView()
}
