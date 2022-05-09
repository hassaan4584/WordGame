//
//  SpanishWord.swift
//  WordGame
//
//  Created by Hassaan Fayyaz Ahmed on 07/05/2022.
//

import Foundation

struct SpanishWord: Decodable, Word {
    /// English representation of the word
    private let textEng: String?
    /// Spanish represenation of the word
    private let textSpa: String?

    enum CodingKeys: String, CodingKey {
        case textEng = "text_eng"
        case textSpa = "text_spa"
    }

    // Conformance to Word Protocol
    var englishWord: String? {
        return self.textEng
    }
    var translatedWord: String? {
        return self.textSpa
    }
}
