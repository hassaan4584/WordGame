//
//  WordAttemptsVCTests.swift
//  WordGameTests
//
//  Created by Hassaan Fayyaz Ahmed on 07/05/2022.
//

import XCTest
@testable import WordGame

class WordAttemptsVCTests: XCTestCase {

    var sut: WordAttemptsVC!

    override func setUpWithError() throws {
        let spanishWords: [SpanishWord] = Constants.getWordList(fileName: Constants.spanishWordsFileName) ?? []
        let wordAttemptsVM = WordAttemptsVM(spanishWordsList: spanishWords)
        self.sut = WordAttemptsVC.createWordAttemptsVC(wordAttemptsVM: wordAttemptsVM, timerDuration: 5.0)
        self.sut.loadView()
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }

    /// When the word and its translation are correct and user presses `Correct` CTA, correct count should be increased
    func testInputProcessing_whenCorrectCTAIsTappedWithMatchingWord_shouldUpdateLabelsCorrectly() throws {
        let spanishWords: [SpanishWord] = Constants.getWordList(fileName: Constants.spanishWordsFileName) ?? []
        self.sut.wordAttemptsVM = WordAttemptsVM(spanishWordsList: spanishWords, correctAnswerProbability: 1.0)
        self.sut.wordAttemptsVM.onAttemptMade = self.sut.updateAttemps(correctCount:wrongCount:)
        // Since VM is instantiated, we need to use getNextRandomWord function to show a word
        _ = self.sut.wordAttemptsVM.getNextRandomWord()
        self.sut.correctButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(self.sut.correctAttemptsCountLabel.text!, "1")
        XCTAssertEqual(self.sut.wrongAttemptsCountLabel.text!, "0")
    }

    /// When translation of a word is wrong and user presses `Correct` CTA, wrong count should be increased
    func testInputProcessing_whenCorrectCTAIsTappedWithNonMatchingWord_shouldUpdateLabelsCorrectly() throws {
        // Arrange
        let spanishWords: [SpanishWord] = Constants.getWordList(fileName: Constants.spanishWordsFileName) ?? []
        self.sut.wordAttemptsVM = WordAttemptsVM(spanishWordsList: spanishWords, correctAnswerProbability: 0.0)
        self.sut.wordAttemptsVM.onAttemptMade = self.sut.updateAttemps(correctCount:wrongCount:)

        // Act
        // Since VM is instantiated, we need to use getNextRandomWord function to show a word
        _ = self.sut.wordAttemptsVM.getNextRandomWord()
        self.sut.correctButton.sendActions(for: .touchUpInside)

        // Assert
        XCTAssertEqual(self.sut.correctAttemptsCountLabel.text!, "0")
        XCTAssertEqual(self.sut.wrongAttemptsCountLabel.text!, "1")
    }

    /// When the word and its translation are correct and user presses `Wrong` CTA, wrong count should be increased
    func testInputProcessing_whenWrongCTAIsTappedWithMatchingWord_shouldUpdateLabelsCorrectly() throws {
        // Arrange
        let spanishWords: [SpanishWord] = Constants.getWordList(fileName: Constants.spanishWordsFileName) ?? []
        self.sut.wordAttemptsVM = WordAttemptsVM(spanishWordsList: spanishWords, correctAnswerProbability: 1.0)
        self.sut.wordAttemptsVM.onAttemptMade = self.sut.updateAttemps(correctCount:wrongCount:)

        // Act
        // Since VM is instantiated, we need to use getNextRandomWord function to show a word
        _ = self.sut.wordAttemptsVM.getNextRandomWord()
        self.sut.wrongButton.sendActions(for: .touchUpInside)

        // Assert
        XCTAssertEqual(self.sut.correctAttemptsCountLabel.text!, "0")
        XCTAssertEqual(self.sut.wrongAttemptsCountLabel.text!, "1")
    }

    /// When translation of a word is wrong and user presses `Wrong` CTA, correct count should be increased
    func testInputProcessing_whenWrongCTAIsTappedWithNonMatchingWord_shouldUpdateLabelsCorrectly() throws {
        // Arrange
        let spanishWords: [SpanishWord] = Constants.getWordList(fileName: Constants.spanishWordsFileName) ?? []
        self.sut.wordAttemptsVM = WordAttemptsVM(spanishWordsList: spanishWords, correctAnswerProbability: 0.0)
        self.sut.wordAttemptsVM.onAttemptMade = self.sut.updateAttemps(correctCount:wrongCount:)

        // Act
        // Since VM is instantiated, we need to use getNextRandomWord function to show a word
        _ = self.sut.wordAttemptsVM.getNextRandomWord()
        self.sut.wrongButton.sendActions(for: .touchUpInside)

        // Assert
        XCTAssertEqual(self.sut.correctAttemptsCountLabel.text!, "1")
        XCTAssertEqual(self.sut.wrongAttemptsCountLabel.text!, "0")
    }

    /// When the closure is not set, the labels should not be updated.
    func testInputProcessing_whenClosureIsNotSet_shouldNotUpdateLabels() throws {
        // Arrange
        let spanishWords: [SpanishWord] = Constants.getWordList(fileName: Constants.spanishWordsFileName) ?? []
        self.sut.wordAttemptsVM = WordAttemptsVM(spanishWordsList: spanishWords, correctAnswerProbability: 1.0)

        // Act
        _ = self.sut.wordAttemptsVM.getNextRandomWord()
        self.sut.correctButton.sendActions(for: .touchUpInside)

        // Assert
        // When UI update closure is not set, the UI should not update
        XCTAssertEqual(self.sut.correctAttemptsCountLabel.text!, "0")
        XCTAssertEqual(self.sut.wrongAttemptsCountLabel.text!, "0")
    }

    /// Testing timer functionality that wrong attempt count increases when timeout occurs
    func testTimer_whenTimerExpires_shouldUpdateWrongLabel() throws {
        // Arrange
        let spanishWords: [SpanishWord] = Constants.getWordList(fileName: Constants.spanishWordsFileName) ?? []
        self.sut.wordAttemptsVM = WordAttemptsVM(spanishWordsList: spanishWords, correctAnswerProbability: 1.0)
        var isWrongAttemptIncreased: Bool = false
        let exp = expectation(for: isWrongAttemptIncreased, description: "Attempt timeout expectation")
        self.sut.wordAttemptsVM.onAttemptMade = { (_, wrongCount) in
            isWrongAttemptIncreased = (wrongCount == 1)
        }

        // Act
        _ = self.sut.wordAttemptsVM.getNextRandomWord()
        self.sut.restartTimer()

        // Assert
        wait(for: [exp], timeout: self.sut.timerDuration+1.0)
    }

}
