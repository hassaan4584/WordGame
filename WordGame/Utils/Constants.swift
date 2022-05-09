//
//  Constants.swift
//  WordGame
//
//  Created by Hassaan Fayyaz Ahmed on 08/05/2022.
//

import Foundation

struct Constants {
    /// Filename for Spanish words
    static var spanishWordsFileName: String { "SpanishWords" }

    /// Reads the list of words from the given filename and returns them in array
    /// - Returns: the list of words
    static func getWordList<T>(fileName: String) -> [T]? where T: Decodable {
        guard let filePath = Bundle.main.url(forResource: fileName, withExtension: ".json"),
              let data = try? Data(contentsOf: filePath), let wordsList = try? JSONDecoder().decode([T].self, from: data) else {
            return nil
        }
        return wordsList
    }

}
