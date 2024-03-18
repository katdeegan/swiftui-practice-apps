//
//  Game.swift
//  HPTrivia
//
//  Created by Katherine Deegan on 3/18/24.
//

import Foundation
import SwiftUI

// ViewModel - runs on main thread
@MainActor
class Game: ObservableObject {
    @Published var gameScore = 0
    @Published var questionScore = 5
    @Published var recentScores = [0, 0, 0]
    
    private var allQuestions: [Question] = []
    private var answeredQuestions: [Int] = [] // track questions that have already been answered so you don't repeat questions
    private let savePath = FileManager.documentsDirectory.appending(path: "SavedScores")
    
    // filter out inactive questions
    var filteredQuestions: [Question] = []
    var currentQuestion = Constants.previewQuestion
    var answers: [String] = []
    
    // computed property to keep track of correct answer
    var correctAnswer: String {
        currentQuestion.answers.first(where: { $0.value == true })!.key
    }
    
    init() {
        // run as soon as a new game is created
        decodeQuestions()
    }
    
    func startGame() {
        gameScore = 0
        questionScore = 5
        answeredQuestions = []
    }
    
    func filterQuestions(to books: [Int]) {
        filteredQuestions = allQuestions.filter{ books.contains($0.book) }
        
    }
    
    func newQuestion() {
        if filteredQuestions.isEmpty {
            // if no books are selected..
            return
        }
        
        if answeredQuestions.count == filteredQuestions.count {
            // all filteredQuestions have been answered
            answeredQuestions = [] // reset
        }
        
        var potentialQuestion = filteredQuestions.randomElement()!
        
        while answeredQuestions.contains(potentialQuestion.id) {
            potentialQuestion = filteredQuestions.randomElement()!
        }
        
        currentQuestion = potentialQuestion
        
        answers = []
        for answer in currentQuestion.answers.keys {
            // loop through dict keys (strings)
            answers.append(answer)
        }
        
        answers.shuffle() // make sure correct answer is not always in same place
        
        questionScore = 5 // reset question score back to 5 each time there is a new score
    }
    
    func correct() {
        answeredQuestions.append(currentQuestion.id)
        
        // update score
        withAnimation {
            gameScore += questionScore
        }
        
    }
    
    func endGame() {
        // store 3 most recent scores
        recentScores[2] = recentScores[1]
        recentScores[1] = recentScores[0]
        recentScores[0] = gameScore
        
        saveScores() // encode scores, write to savePath
    }
    func loadScores() {
        do {
            let data = try Data(contentsOf: savePath)
            recentScores = try JSONDecoder().decode([Int].self, from: data)
        } catch {
            recentScores = [0, 0, 0] // if we can't load any scores from saved file
        }
    }
    
    private func saveScores() {
        do {
            let data = try JSONEncoder().encode(recentScores)
            try data.write(to: savePath)
        } catch {
            print("Unable to save data: \(error)")
        }
    }
    
    private func decodeQuestions() {
        if let url = Bundle.main.url(forResource: "trivia", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                allQuestions = try decoder.decode([Question].self, from: data)
                filteredQuestions = allQuestions
            } catch {
                print("Error decoding JSON data: \(error)")
            }
        }
    }
}
