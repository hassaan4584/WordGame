//
//  WordPair.swift
//  WordGame
//
//  Created by Hassaan Fayyaz Ahmed on 07/05/2022.
//

import Foundation

/// This is used in keeping track of information that is displayed to user
struct WordPair {
    /// Possible english for the given translated word
    let englishWord: String
    /// Possible translation of the given english word
    let translatedWord: String
    /// Represents if the given english word and its translation are correct
    let isTranslationCorrect: Bool
}
