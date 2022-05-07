//
//  SpanishWord.swift
//  WordGame
//
//  Created by Hassaan Fayyaz Ahmed on 07/05/2022.
//

import Foundation

struct SpanishWord: Decodable {
    /// English representation of the word
    let textEng: String?
    /// Spanish represenation of the word
    let textSpa: String?

    enum CodingKeys: String, CodingKey {
        case textEng = "text_eng"
        case textSpa = "text_spa"
    }
}
