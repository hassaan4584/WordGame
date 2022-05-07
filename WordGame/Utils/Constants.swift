//
//  Constants.swift
//  WordGame
//
//  Created by Hassaan Fayyaz Ahmed on 08/05/2022.
//

import Foundation

struct Constants {

    static func getSpanishWords() -> WordsList? {
        guard let filePath = Bundle.main.url(forResource: "SpanishWords", withExtension: ".json"),
              let data = try? Data(contentsOf: filePath), let wordsList = try? JSONDecoder().decode([SpanishWord].self, from: data) else {
            return nil
        }
        return wordsList
    }

}
