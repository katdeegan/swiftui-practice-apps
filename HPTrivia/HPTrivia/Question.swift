//
//  Question.swift
//  HPTrivia
//
//  Created by Katherine Deegan on 3/18/24.
//

import Foundation

struct Question: Codable {
    // model for JSON trivia question data
    
    let id: Int
    let question: String
    var answers: [String: Bool] = [:] // initialized empty dict, but var bc we need to update to hold answers dict
    let book: Int
    let hint: String
    
    enum QuestionKeys: String, CodingKey {
        // cases for each top-level JSON key
        case id
        case question
        case answer
        case wrong
        case book
        case hint
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: QuestionKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        
        question = try container.decode(String.self, forKey: .question)
        
        book = try container.decode(Int.self, forKey: .book)
        
        hint = try container.decode(String.self, forKey: .hint)
        
        // update answers dictionary
        let correctAnswer = try container.decode(String.self, forKey: .answer)
        answers[correctAnswer] = true
        
        let wrongAnswers = try container.decode([String].self, forKey: .wrong)
        for answer in wrongAnswers {
            answers[answer] = false
        }
    }
}
