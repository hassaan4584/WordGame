//
//  WordsList.swift
//  WordGame
//
//  Created by Hassaan Fayyaz Ahmed on 07/05/2022.
//

import Foundation

typealias SpanishWordsList = [SpanishWord]
protocol Word {
    var englishWord: String { get }
    var translatedWord: String { get }
}
