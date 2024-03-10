//
//  FetchController.swift
//  BBQuotes
//
//  Created by Katherine Deegan on 3/8/24.
//

import Foundation

struct FetchController {
    // networking - fetch data online
    // retrieves data from API
    
    // possible network errors - server is down, bad internet
    enum NetworkError: Error {
        case badUrl, badResponse
    }
    
    private let baseURL = URL(string: "https://breaking-bad-api-six.vercel.app/api")!
    
    // async - function needs to run in background
    // throw - function may throw an error
    // building url where show="Breaking Bad": https://breaking-bad-api-six.vercel.app/api/quotes/random?production=Breaking+Bad
    func fetchQuote(from show: String) async throws -> Quote {
        let quoteUrl = baseURL.appending(path: "quotes/random")
        var quoteComponents = URLComponents(url: quoteUrl, resolvingAgainstBaseURL: true)
        let quoteQueryItem = URLQueryItem(name: "production", value: show.replaceSpaceWithPlus)
        
        quoteComponents?.queryItems = [quoteQueryItem]
        
        guard let fetchURL = quoteComponents?.url else {
            throw NetworkError.badUrl
        }
        
        // await keyword goes with async
        // try - indicates error might be thrown
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        // check that response is of type we were expecting
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        // if response/ststus code are OK:
        let quote = try JSONDecoder().decode(Quote.self, from: data)
        
        return quote
    }
    
    func fetchCharacter(_ name: String) async throws -> Character {
        
        let characterURL = baseURL.appending(path: "characters")
        var characterComponents = URLComponents(url: characterURL, resolvingAgainstBaseURL: true)
        let characterQueryItem = URLQueryItem(name: "name", value: name.replaceSpaceWithPlus)
        
        characterComponents?.queryItems = [characterQueryItem]
            
        guard let fetchURL = characterComponents?.url else {
            throw NetworkError.badUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        // check that response is of type we were expecting
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        // if response/ststus code are OK:
        let decoder = JSONDecoder()
        // convert between snake_case in JSON to camelCase in model
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let characters = try decoder.decode([Character].self, from: data)
        
        return characters[0]

        
        
        
    }
}
