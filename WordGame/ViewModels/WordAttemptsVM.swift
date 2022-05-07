//
//  WordAttemptsVM.swift
//  WordGame
//
//  Created by Hassaan Fayyaz Ahmed on 07/05/2022.
//

import Foundation
import UIKit

final class WordAttemptsVM {
    /// Possible types of attempts user can make
    enum UserAttempt {
        /// User Selected `Correct` button
        case correct
        /// User Selected `Wrong` button
        case wrong
    }

    private let spanishWordsList: [SpanishWord]
    /// The probability that a given word and its translation are correct
    private let correctAnswerProbability: Double
    /// Index of the word that will be used in the next iteration
    private var nextWordIndex: Int = 0
    /// Total correct attempts user has made so far
    private var correctAttemptsCount: Int = 0
    /// Total worng attempts user has made so far
    private var wrongAttemptsCount: Int = 0
    /// `WordPair` that is currently shown to user
    var currentWord: WordPair?

    init(spanishWordsList: [SpanishWord], correctAnswerProbability: Double=0.25) {
        self.spanishWordsList = spanishWordsList
        self.correctAnswerProbability = correctAnswerProbability
    }

    /// This function returns true with the given probability
    /// - Parameter probability: The probability of returning true
    /// - Returns: returns true with the given probability
    func shouldUseCorrect(probability: Double) -> Bool {
        let intProbablity: Int = Int(probability * 100)
        let rand = Int.random(in: 1...100)
        return rand <= intProbablity
    }

    /// Creates a `WordPair`  that may or may not have correct translation.
    /// - Parameters:
    ///   - spanishWord: The `spanishWord.textEng` is the english word for which its correct or wrong translation is to be shown
    ///   - wordsList: The list of words from which some incorrect word will be used
    /// - Returns: if no error happens, it will return `WordPair` object
    func generateRandomWordPair(spanishWord: SpanishWord, wordsList: SpanishWordsList) -> WordPair? {
        guard let englishWord = spanishWord.textEng, let spanishWord = spanishWord.textSpa else {
            return nil
        }
        guard !shouldUseCorrect(probability: self.correctAnswerProbability) else {
            return WordPair(englishWord: englishWord, translatedWord: spanishWord, isTranslationCorrect: true)
        }
        guard let wordIndex = (wordsList.firstIndex { $0.textEng == englishWord && $0.textSpa == spanishWord }) else { return nil }

        let nextIndex: Int = (wordIndex + 2) % wordsList.count
        guard let randomSpanishWord = wordsList[nextIndex].textSpa else { return nil }

        // When there is only one word in the array, it will always return correct answer
        return WordPair(englishWord: englishWord, translatedWord: randomSpanishWord, isTranslationCorrect: false)
    }

    /// This function will create a new `WordPair` based on the given requirements. This will be used to display to user
    /// - Returns: a new `WordPair` object
    func getNextRandomWord() -> WordPair? {
        guard self.nextWordIndex < self.spanishWordsList.count else { return nil }
        guard self.spanishWordsList.count > 0 else { return nil }

        let spanishWord = self.spanishWordsList[self.nextWordIndex]
        self.nextWordIndex = (self.nextWordIndex + 1) % self.spanishWordsList.count
        self.currentWord = self.generateRandomWordPair(spanishWord: spanishWord, wordsList: self.spanishWordsList)
        return self.currentWord
    }

    /// Processes the given input  by the user and return attempts count
    /// - Parameters:
    ///   - userAttempt: Representing the user action
    ///   - givenWord: The `WordPair` thats shown to the user
    /// - Returns: A tuple with `correct` and `wrong` counts
    func processUserAttempt(userAttempt: UserAttempt, givenWord: WordPair) -> (correctCount: Int, wrongCount: Int) {
        switch userAttempt {
        case .correct:
            if givenWord.isTranslationCorrect {
                self.correctAttemptsCount += 1
            } else {
                self.wrongAttemptsCount += 1
            }
        case .wrong:
            if givenWord.isTranslationCorrect {
                self.wrongAttemptsCount += 1
            } else {
                self.correctAttemptsCount += 1
            }
        }
        return (self.correctAttemptsCount, self.wrongAttemptsCount)
    }
}
