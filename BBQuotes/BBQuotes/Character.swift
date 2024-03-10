//
//  Character.swift
//  BBQuotes
//
//  Created by Katherine Deegan on 3/8/24.
//

import Foundation

struct Character: Decodable {
    let name: String
    let birthday: String
    let occupations: [String]
    let images: [URL] // collection of url Strings in JSON
    let aliases: [String]
    let portrayedBy: String
}
