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

    /// Possible reasons why the game has to end
    enum EndGameReason: Int {
        /// When the number of wrong attempts are used
        case wrongAttempts
        /// When the total number of words for this round are attempted
        case totalWords
    }

    /// This contains the list of words, these words could be either Spanish or German or some other
    private let wordsList: [Word]
    /// The probability that a given word and its translation are correct
    private let correctAnswerProbability: Double
    /// Index of the word that will be used in the next iteration
    private var nextWordIndex: Int = 0
    /// Total correct attempts user has made so far
    private var correctAttemptsCount: Int = 0
    /// Total worng attempts user has made so far
    private var wrongAttemptsCount: Int = 0
    /// Maximum attempts allowed to the user OR the maximum number of words shown to the user
    private let totalAllowedWordAttempts: Int
    /// Maximum wrong attempts allowed
    private let allowedWrongAttempts: Int
    /// `WordPair` that is currently shown to user
    var currentWord: WordPair?

    /// This will get called when the game has to end
    var endGame: ((EndGameReason) -> Void)?
    /// This will be used to update UI with `correct` and `wrong` attempt counts
    var onAttemptMade: ((_ correctCount: Int, _ wrongCount: Int) -> Void)?

    init(spanishWordsList: [Word], correctAnswerProbability: Double=0.25, totalAllowedWordAttempts: Int=15, allowedWrongAttempts: Int=3) {
        self.wordsList = spanishWordsList
        self.correctAnswerProbability = correctAnswerProbability
        self.totalAllowedWordAttempts = totalAllowedWordAttempts
        self.allowedWrongAttempts = allowedWrongAttempts
    }

    /// This function returns true with the given probability
    /// - Parameter probability: The probability of returning true
    /// - Returns: returns true with the given probability
    func shouldUseCorrectOption(probability: Double) -> Bool {
        let intProbablity: Int = Int(probability * 100)
        let rand = Int.random(in: 1...100)
        return rand <= intProbablity
    }

    /// Creates a `WordPair`  that may or may not have correct translation.
    /// - Parameters:
    ///   - spanishWord: The `spanishWord.textEng` is the english word for which its correct or wrong translation is to be shown
    ///   - wordsList: The list of words from which some incorrect word will be used
    /// - Returns: if no error happens, it will return `WordPair` object
    func generateRandomWordPair(word: Word, wordsList: WordsList) -> WordPair? {
        guard let englishWord = word.englishWord, let spanishWord = word.translatedWord else {
            return nil
        }
        guard !shouldUseCorrectOption(probability: self.correctAnswerProbability) else {
            return WordPair(englishWord: englishWord, translatedWord: spanishWord, isTranslationCorrect: true)
        }
        guard wordsList.count > 2 else {
            return WordPair(englishWord: englishWord, translatedWord: spanishWord, isTranslationCorrect: true)
        }
        guard let wordIndex = (wordsList.firstIndex { $0.englishWord == englishWord && $0.translatedWord == spanishWord }) else { return nil }

        let nextIndex: Int = (wordIndex + 2) % wordsList.count
        guard let randomTranslation = wordsList[nextIndex].translatedWord else { return nil }

        // When there is only one word in the array, it will always return correct answer
        return WordPair(englishWord: englishWord, translatedWord: randomTranslation, isTranslationCorrect: false)
    }

    /// This function will create a new `WordPair` based on the given requirements. This will be used to display to user
    /// - Returns: a new `WordPair` object
    func getNextRandomWord() -> WordPair? {
        guard self.nextWordIndex < self.wordsList.count else { return nil }
        guard self.wordsList.count > 0 else { return nil }

        let spanishWord = self.wordsList[self.nextWordIndex]
        self.nextWordIndex = (self.nextWordIndex + 1) % self.wordsList.count
        self.currentWord = self.generateRandomWordPair(word: spanishWord, wordsList: self.wordsList)
        return self.currentWord
    }

    /// Processes the given input  by the user and return attempts count
    /// - Parameters:
    ///   - userAttempt: Representing the user action
    ///   - givenWord: The `WordPair` thats shown to the user
    /// - Returns: A tuple with `correct` and `wrong` attempt counts
    func processUserAttempt(userAttempt: UserAttempt, givenWord: WordPair) {
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
        self.onAttemptMade?(self.correctAttemptsCount, self.wrongAttemptsCount)
    }

    /// Processes timeout as wrong attempt
    /// - Returns: A tuple with updated `correct` and `wrong` attempt counts
    func processTimerExpiryAttempt() {
        self.wrongAttemptsCount += 1
        self.onAttemptMade?(self.correctAttemptsCount, self.wrongAttemptsCount)
    }
    /// Re-set the data for game restart
    func updateDataForGameRestart() {
        self.correctAttemptsCount = 0
        self.wrongAttemptsCount = 0
        self.onAttemptMade?(self.correctAttemptsCount, self.wrongAttemptsCount)
    }
    /// When game ending conditions are met, this will inform its VC to take respective
    /// - Returns: Boolean depending on if the endGame action has to be taken or not
    func verifyGameEndingConditions() -> Bool {
        if (correctAttemptsCount + wrongAttemptsCount) == self.totalAllowedWordAttempts {
            self.endGame?(.totalWords)
            return true
        } else if self.wrongAttemptsCount == self.allowedWrongAttempts {
            self.endGame?(.wrongAttempts)
            return true
        }
        return false
    }
}
