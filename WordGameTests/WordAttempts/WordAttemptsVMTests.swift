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
        let wordList: [SpanishWord] = Constants.getWordList(fileName: Constants.spanishWordsFileName) ?? []
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
        let wordList: [SpanishWord] = Constants.getWordList(fileName: Constants.spanishWordsFileName) ?? []
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
        let wordList: [SpanishWord] = Constants.getWordList(fileName: Constants.spanishWordsFileName) ?? []
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
        let wordList: [SpanishWord] = Constants.getWordList(fileName: Constants.spanishWordsFileName) ?? []
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
        let wordList: [SpanishWord] = Constants.getWordList(fileName: Constants.spanishWordsFileName) ?? []
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
        let wordList: [SpanishWord] = Constants.getWordList(fileName: Constants.spanishWordsFileName) ?? []
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
        let wordList: [SpanishWord] = Constants.getWordList(fileName: Constants.spanishWordsFileName) ?? []
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
        let wordList: [SpanishWord] = Constants.getWordList(fileName: Constants.spanishWordsFileName) ?? []
        let correctProbability = 1.0
        self.sut = WordAttemptsVM(spanishWordsList: wordList, correctAnswerProbability: correctProbability)
        var correct = 0, wrong = 0
        self.sut.onAttemptMade = { (correctCount, wrongCount) in
            correct = correctCount
            wrong = wrongCount
        }

        // Act
        let wordPair = self.sut.getNextRandomWord()
        self.sut.processUserAttempt(userAttempt: .correct, givenWord: wordPair!)

        // Assert
        XCTAssertEqual(correct, 1)
        XCTAssertEqual(wrong, 0)
    }

    /// When the pair is matching AND user presses the `Wrong` CTA. The attempt will be considered as wrong
    func testProcessUserAttempt_whenItsVeryFirstIteration_userMakesCorrectAttemptWithWrongTranslation() throws {
        // Arrange
        let wordList: [SpanishWord] = Constants.getWordList(fileName: Constants.spanishWordsFileName) ?? []
        let correctProbability = 1.0
        self.sut = WordAttemptsVM(spanishWordsList: wordList, correctAnswerProbability: correctProbability)
        var correct = 0, wrong = 0
        self.sut.onAttemptMade = { (correctCount, wrongCount) in
            correct = correctCount
            wrong = wrongCount
        }
        // Act
        let wordPair = self.sut.getNextRandomWord()
        self.sut.processUserAttempt(userAttempt: .wrong, givenWord: wordPair!)

        // Assert
        XCTAssertEqual(correct, 0)
        XCTAssertEqual(wrong, 1)
    }

    /// When the pair is not matching AND user presses the `Correct` CTA. The attempt will be considered as wrong
    func testProcessUserAttempt_whenItsVeryFirstIteration_userMakesWrongAttemptWithMatchingTranslation() throws {
        // Arrange
        let wordList: [SpanishWord] = Constants.getWordList(fileName: Constants.spanishWordsFileName) ?? []
        let correctProbability = 0.0
        self.sut = WordAttemptsVM(spanishWordsList: wordList, correctAnswerProbability: correctProbability)
        var correct = 0, wrong = 0
        self.sut.onAttemptMade = { (correctCount, wrongCount) in
            correct = correctCount
            wrong = wrongCount
        }

        // Act
        let wordPair = self.sut.getNextRandomWord()
        self.sut.processUserAttempt(userAttempt: .correct, givenWord: wordPair!)

        // Assert
        XCTAssertEqual(correct, 0)
        XCTAssertEqual(wrong, 1)
    }

    /// When the pair is not matching AND user presses the `wrong` CTA. The attempt will be considered as correct
    func testProcessUserAttempt_whenItsVeryFirstIteration_userMakesWrongAttemptWithWrongTranslation() throws {
        // Arrange
        let wordList: [SpanishWord] = Constants.getWordList(fileName: Constants.spanishWordsFileName) ?? []
        let correctProbability = 0.0
        self.sut = WordAttemptsVM(spanishWordsList: wordList, correctAnswerProbability: correctProbability)
        var correct = 0, wrong = 0
        self.sut.onAttemptMade = { (correctCount, wrongCount) in
            correct = correctCount
            wrong = wrongCount
        }

        // Act
        let wordPair = self.sut.getNextRandomWord()
        self.sut.processUserAttempt(userAttempt: .wrong, givenWord: wordPair!)

        // Assert
        XCTAssertEqual(correct, 1)
        XCTAssertEqual(wrong, 0)
    }

    /// When user performs 3 wrong attempts, the endGame closure should be called
    func testEndingConditions_whenUserMakes3WrongAttempts_endGameClosureShouldBeCalled() throws {
        // Arrange
        let wordList: [SpanishWord] = Constants.getWordList(fileName: Constants.spanishWordsFileName) ?? []
        let correctProbability = 0.0
        self.sut = WordAttemptsVM(spanishWordsList: wordList, correctAnswerProbability: correctProbability, allowedWrongAttempts: 3)
        let quitExpectaion = expectation(description: "End game expectation")
        self.sut.endGame = endGame(quitReason: )

        // Act
        let wordPair1 = self.sut.getNextRandomWord()
        self.sut.processUserAttempt(userAttempt: .correct, givenWord: wordPair1!)
        let wordPair2 = self.sut.getNextRandomWord()
        self.sut.processUserAttempt(userAttempt: .correct, givenWord: wordPair2!)
        let wordPair3 = self.sut.getNextRandomWord()
        self.sut.processUserAttempt(userAttempt: .correct, givenWord: wordPair3!)

        _ = self.sut.verifyGameEndingConditions()
        // Assert
        func endGame(quitReason: WordAttemptsVM.EndGameReason) {
            quitExpectaion.fulfill()
        }
        self.wait(for: [quitExpectaion], timeout: 0.1)
    }

    /// When total allowed attempts are made, the endGame closure should be called
    func testEndingConditions_whenTotalAllowedAttemptsAreMade_endGameClosureShouldBeCalled() throws {
        // Arrange
        let wordList: [SpanishWord] = Constants.getWordList(fileName: Constants.spanishWordsFileName) ?? []
        let correctProbability = 0.0
        let totalAllowedAttempts = 15
        self.sut = WordAttemptsVM(spanishWordsList: wordList, correctAnswerProbability: correctProbability, allowedWrongAttempts: 3)
        let quitExpectaion = expectation(description: "End game expectation")
        self.sut.endGame = endGame(quitReason: )

        // Act
        for _ in 0..<totalAllowedAttempts {
            let wordPair1 = self.sut.getNextRandomWord()
            self.sut.processUserAttempt(userAttempt: .wrong, givenWord: wordPair1!)
            _ = self.sut.verifyGameEndingConditions()
        }

        // Assert
        func endGame(quitReason: WordAttemptsVM.EndGameReason) {
            quitExpectaion.fulfill()
        }
        self.wait(for: [quitExpectaion], timeout: 0.1)
    }

    /// When total attempts are not yet made, the game should not end
    func testEndingConditions_whenTotalAllowedAttemptsAreNotYetMade_endGameClosureShouldNotBeCalled() throws {
        // Arrange
        let wordList: [SpanishWord] = Constants.getWordList(fileName: Constants.spanishWordsFileName) ?? []
        let correctProbability = 0.0
        let totalAllowedAttempts = 15
        self.sut = WordAttemptsVM(spanishWordsList: wordList, correctAnswerProbability: correctProbability, allowedWrongAttempts: 3)
        self.sut.endGame = endGame(quitReason: )

        // Act
        for _ in 0..<totalAllowedAttempts-1 {
            let wordPair1 = self.sut.getNextRandomWord()
            self.sut.processUserAttempt(userAttempt: .wrong, givenWord: wordPair1!)
            _ = self.sut.verifyGameEndingConditions()
        }
        // Assert
        func endGame(quitReason: WordAttemptsVM.EndGameReason) {
            XCTFail("QuitGame closure should not be called")
        }
    }
}
