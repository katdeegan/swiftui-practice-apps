//
//  ViewModel.swift
//  BBQuotes
//
//  Created by Katherine Deegan on 3/8/24.
//

import Foundation

// structs are more used for when data isn't going to change
// classes are more changeable, multiple properties can be used to point to same class

@MainActor // running on main thread because it is so closely tied with UI
class ViewModel: ObservableObject {
    // ObservableObject -> @Published properties can be observed by other components (i.e. Views) so components may update when there's changed to ObservableObject
    enum Status {
        case notStarted
        case fetching
        case success(data: (quote: Quote, character: Character))
        case failed(error:Error)
        
    }
    
    // property that Views can observe in ObservableObject class
    // private(set) -> only ViewModel can change property, but other objects may see property
    @Published private(set) var status: Status = .notStarted // already initialized (don't need to add to init method)
    
    private let controller: FetchController
    
    init(controller: FetchController) {
        // ViewModel will be initialized in View, and FetchController object must be supplied
        self.controller = controller
    }
    
    func getData(for show: String) async {
        status = .fetching
        
        do {
            // when using an asyn throws function, you need to use try await
            let quote = try await controller.fetchQuote(from: show)
            
            let character = try await controller.fetchCharacter(quote.character)
            
            status = .success(data: (quote: quote, character: character))
        } catch {
            status = .failed(error: error)
        }
    }
}
