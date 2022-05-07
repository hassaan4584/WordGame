//
//  Word.swift
//  WordGame
//
//  Created by Hassaan Fayyaz Ahmed on 07/05/2022.
//

import Foundation

typealias WordsList = [Word]

/// This is a protocol for model that will be used to support multiple languages in the future
protocol Word {
    /// Meaning in English
    var englishWord: String? { get }
    /// Associated meaning in the given language
    var translatedWord: String? { get }
}
