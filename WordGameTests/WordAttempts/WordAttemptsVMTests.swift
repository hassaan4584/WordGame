//
//  WordAttemptsVMTests.swift
//  WordGameTests
//
//  Created by Hassaan Fayyaz Ahmed on 07/05/2022.
//

import XCTest
@testable import WordGame

class WordAttemptsVMTests: XCTestCase {
    var sut: WordAttemptsVM!

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }

    /// When correct probability is 1, the `shouldUseCorrectOption()` function should always return `true`
    func testRandomFunction_whenCorrectProbabilityIs1_shouldAlwaysReturnTrue() throws {
        // Arrange
        let correctProbability = 1.0
        self.sut = WordAttemptsVM(spanishWordsList: [], correctAnswerProbability: correctProbability)

        // Act
        for _ in 0..<10 {
            let shouldUseRandom = self.sut.shouldUseCorrectOption(probability: correctProbability)
            // Assert
            XCTAssertTrue(shouldUseRandom, "When correct answer probability is 1, never use random")
        }
    }

    /// When correct probability is 0, the `shouldUseCorrectOption()` function should always return `false`
    func testRandomFunction_whenCorrectProbabilityIs0_shouldAlwaysReturnFalse() throws {
        // Arrange
        let correctProbability = 0.0
        self.sut = WordAttemptsVM(spanishWordsList: [], correctAnswerProbability: correctProbability)

        // Act
        for _ in 0..<10 {
            let shouldUseRandom = self.sut.shouldUseCorrectOption(probability: correctProbability)
            // Assert
            XCTAssertFalse(shouldUseRandom, "When correct answer probability is 1, never use random")
        }
    }

    /// When the probability of Correct is 1, all answers should be the correct WordPair
    func testGenerateRandomChoice_whenCorrectProbabilityIs1_shouldAlwaysReturnCorrectAnswer() throws {
        // Arrange
        guard let wordList = Constants.getSpanishWords() else {
            XCTFail("Unable to get words List")
            return
        }

        let correctProbability = 1.0
        self.sut = WordAttemptsVM(spanishWordsList: wordList, correctAnswerProbability: correctProbability)

        for i in 0..<wordList.count {
            // Act
            let spanishWord = wordList[i]
            let wordPair = self.sut.generateRandomWordPair(word: spanishWord, wordsList: wordList)

            // Assert
            XCTAssertTrue(wordPair!.isTranslationCorrect)
            XCTAssertEqual(wordPair!.englishWord, spanishWord.englishWord)
            XCTAssertEqual(wordPair!.translatedWord, spanishWord.translatedWord)
        }
    }

    /// When the probability of Correct is 1, all answers should be the correct False
    func testGenerateRandomChoice_whenCorrectProbabilityIs0_shouldAlwaysReturnWrongAnswer() throws {
        // Arrange
        guard let wordList = Constants.getSpanishWords() else {
            XCTFail("Unable to get words List")
            return
        }

        let correctProbability = 0.0
        self.sut = WordAttemptsVM(spanishWordsList: wordList, correctAnswerProbability: correctProbability)

        for i in 0..<wordList.count {
            // Act
            let spanishWord = wordList[i]
            let wordPair = self.sut.generateRandomWordPair(word: spanishWord, wordsList: wordList)

            // Assert
            // English Word should be equal but spanish word should not be equal
            XCTAssertFalse(wordPair!.isTranslationCorrect)
            XCTAssertEqual(wordPair!.englishWord, spanishWord.englishWord)
            XCTAssertNotEqual(wordPair!.translatedWord, spanishWord.translatedWord)
        }
    }

    /// When the index would become out of range for generating random Choice
    func testGenerateRandomChoice_whenCorrectProbabilityIs0ForLastIndex_shouldAlwaysReturnWrongAnswer() throws {
        // Arrange
        guard let wordList = Constants.getSpanishWords() else {
            XCTFail("Unable to get words List")
            return
        }

        let correctProbability = 0.0
        self.sut = WordAttemptsVM(spanishWordsList: wordList, correctAnswerProbability: correctProbability)
        let spanishWord = wordList[296]

        // Act
        let wordPair = self.sut.generateRandomWordPair(word: spanishWord, wordsList: wordList)

        // Assert
        // English Word should be equal but spanish word should not be equal
        XCTAssertFalse(wordPair!.isTranslationCorrect)
        XCTAssertEqual(wordPair!.englishWord, spanishWord.englishWord)
        XCTAssertNotEqual(wordPair!.translatedWord, spanishWord.translatedWord)
    }

    /// When word list is empty, it should return the passed pair
    func testGenerateRandomChoice_whenCorrectProbabilityIs0ForEmptyList_shouldAlwaysOriginalPair() throws {
        // Arrange
        guard let wordList = Constants.getSpanishWords() else {
            XCTFail("Unable to get words List")
            return
        }

        let correctProbability = 0.0
        self.sut = WordAttemptsVM(spanishWordsList: [], correctAnswerProbability: correctProbability)
        let spanishWord = wordList[296]

        // Act
        let wordPair = self.sut.generateRandomWordPair(word: spanishWord, wordsList: [])

        // Assert
        XCTAssertNotNil(wordPair)
        XCTAssertEqual(wordPair!.englishWord, spanishWord.englishWord)
        XCTAssertEqual(wordPair!.translatedWord, spanishWord.translatedWord)
    }

    func testGetNextRandomWord_whenItsVeryFirstIteration_FirstItemShouldBeReturned() throws {
        // Arrange
        guard let wordList = Constants.getSpanishWords() else {
            XCTFail("Unable to get words List")
            return
        }

        let correctProbability = 1.0
        self.sut = WordAttemptsVM(spanishWordsList: wordList, correctAnswerProbability: correctProbability)

        // Act
        let spanishWord = wordList[0] // Function should return first element of list
        let wordPair = self.sut.getNextRandomWord()

        // Assert
        XCTAssertNotNil(wordPair)
        XCTAssertTrue(wordPair!.isTranslationCorrect)
        XCTAssertEqual(wordPair!.englishWord, spanishWord.englishWord)
        XCTAssertEqual(wordPair!.translatedWord, spanishWord.translatedWord)
    }

    /// When the list contains 1 item and the correct probability is 0, the item returned should still be correct
    func testGetNextRandomWord_whenListContainsOnly1Item_ItShouldReturnCorrectPair() throws {
        // Arrange
        guard let wordList = Constants.getSpanishWords() else {
            XCTFail("Unable to get words List")
            return
        }

        let correctProbability = 0.0
        self.sut = WordAttemptsVM(spanishWordsList: [wordList[0]], correctAnswerProbability: correctProbability)

        // Act
        let spanishWord = wordList[0] // Function should return first element of list
        let wordPair = self.sut.getNextRandomWord()

        // Assert
        XCTAssertNotNil(wordPair)
        XCTAssertTrue(wordPair!.isTranslationCorrect)
        XCTAssertEqual(wordPair!.englishWord, spanishWord.englishWord)
        XCTAssertEqual(wordPair!.translatedWord, spanishWord.translatedWord)
    }

    /// When the list contains 2 items and the correct probability is 0, the item returned should still be correct
    func testGetNextRandomWord_whenListContains2Items_ItShouldReturnCorrectPair() throws {
        // Arrange
        guard let wordList = Constants.getSpanishWords() else {
            XCTFail("Unable to get words List")
            return
        }

        let correctProbability = 0.0
        self.sut = WordAttemptsVM(spanishWordsList: [wordList[0], wordList[1]], correctAnswerProbability: correctProbability)

        // Act
        let spanishWord = wordList[0] // Function should return first element of list
        let wordPair = self.sut.getNextRandomWord()

        // Assert
        XCTAssertNotNil(wordPair)
        XCTAssertTrue(wordPair!.isTranslationCorrect)
        XCTAssertEqual(wordPair!.englishWord, spanishWord.englishWord)
        XCTAssertEqual(wordPair!.translatedWord, spanishWord.translatedWord)
    }

    /// When the pair is matching AND user presses the `Correct` CTA. The attempt will be considered as correct
    func testProcessUserAttempt_whenItsVeryFirstIteration_userMakesCorrectAttemptWithMatchingTranslation() throws {
        // Arrange
        guard let wordList = Constants.getSpanishWords() else {
            XCTFail("Unable to get words List")
            return
        }

        let correctProbability = 1.0
        self.sut = WordAttemptsVM(spanishWordsList: wordList, correctAnswerProbability: correctProbability)

        // Act
        let wordPair = self.sut.getNextRandomWord()
        let attempts = self.sut.processUserAttempt(userAttempt: .correct, givenWord: wordPair!)

        // Assert
        XCTAssertEqual(attempts.correctCount, 1)
        XCTAssertEqual(attempts.wrongCount, 0)
    }

    /// When the pair is matching AND user presses the `Wrong` CTA. The attempt will be considered as wrong
    func testProcessUserAttempt_whenItsVeryFirstIteration_userMakesCorrectAttemptWithWrongTranslation() throws {
        // Arrange
        guard let wordList = Constants.getSpanishWords() else {
            XCTFail("Unable to get words List")
            return
        }

        let correctProbability = 1.0
        self.sut = WordAttemptsVM(spanishWordsList: wordList, correctAnswerProbability: correctProbability)

        // Act
        let wordPair = self.sut.getNextRandomWord()
        let attempts = self.sut.processUserAttempt(userAttempt: .wrong, givenWord: wordPair!)

        // Assert
        XCTAssertEqual(attempts.correctCount, 0)
        XCTAssertEqual(attempts.wrongCount, 1)
    }

    /// When the pair is not matching AND user presses the `Correct` CTA. The attempt will be considered as wrong
    func testProcessUserAttempt_whenItsVeryFirstIteration_userMakesWrongAttemptWithMatchingTranslation() throws {
        // Arrange
        guard let wordList = Constants.getSpanishWords() else {
            XCTFail("Unable to get words List")
            return
        }

        let correctProbability = 0.0
        self.sut = WordAttemptsVM(spanishWordsList: wordList, correctAnswerProbability: correctProbability)

        // Act
        let wordPair = self.sut.getNextRandomWord()
        let attempts = self.sut.processUserAttempt(userAttempt: .correct, givenWord: wordPair!)

        // Assert
        XCTAssertEqual(attempts.correctCount, 0)
        XCTAssertEqual(attempts.wrongCount, 1)
    }

    /// When the pair is not matching AND user presses the `wrong` CTA. The attempt will be considered as correct
    func testProcessUserAttempt_whenItsVeryFirstIteration_userMakesWrongAttemptWithWrongTranslation() throws {
        // Arrange
        guard let wordList = Constants.getSpanishWords() else {
            XCTFail("Unable to get words List")
            return
        }

        let correctProbability = 0.0
        self.sut = WordAttemptsVM(spanishWordsList: wordList, correctAnswerProbability: correctProbability)

        // Act
        let wordPair = self.sut.getNextRandomWord()
        let attempts = self.sut.processUserAttempt(userAttempt: .wrong, givenWord: wordPair!)

        // Assert
        XCTAssertEqual(attempts.correctCount, 1)
        XCTAssertEqual(attempts.wrongCount, 0)
    }
}
