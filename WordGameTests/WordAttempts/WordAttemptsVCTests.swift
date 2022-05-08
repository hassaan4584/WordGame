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
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let attemptsVC = storyboard.instantiateInitialViewController() as? WordAttemptsVC
        self.sut = attemptsVC!
        self.sut.loadView()
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }

    /// When the word and its translation are correct and user presses `Correct` CTA, correct count should be increased
    func testInputProcessing_whenCorrectCTAIsTappedWithMatchingWord_shouldUpdateLabelsCorrectly() throws {
        let spanishWords = Constants.getSpanishWords() ?? []
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
        let spanishWords = Constants.getSpanishWords() ?? []
        self.sut.wordAttemptsVM = WordAttemptsVM(spanishWordsList: spanishWords, correctAnswerProbability: 0.0)
        self.sut.wordAttemptsVM.onAttemptMade = self.sut.updateAttemps(correctCount:wrongCount:)
        // Since VM is instantiated, we need to use getNextRandomWord function to show a word
        _ = self.sut.wordAttemptsVM.getNextRandomWord()
        self.sut.correctButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(self.sut.correctAttemptsCountLabel.text!, "0")
        XCTAssertEqual(self.sut.wrongAttemptsCountLabel.text!, "1")
    }

    /// When the word and its translation are correct and user presses `Wrong` CTA, wrong count should be increased
    func testInputProcessing_whenWrongCTAIsTappedWithMatchingWord_shouldUpdateLabelsCorrectly() throws {
        let spanishWords = Constants.getSpanishWords() ?? []
        self.sut.wordAttemptsVM = WordAttemptsVM(spanishWordsList: spanishWords, correctAnswerProbability: 1.0)
        self.sut.wordAttemptsVM.onAttemptMade = self.sut.updateAttemps(correctCount:wrongCount:)
        // Since VM is instantiated, we need to use getNextRandomWord function to show a word
        _ = self.sut.wordAttemptsVM.getNextRandomWord()
        self.sut.wrongButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(self.sut.correctAttemptsCountLabel.text!, "0")
        XCTAssertEqual(self.sut.wrongAttemptsCountLabel.text!, "1")
    }

    /// When translation of a word is wrong and user presses `Wrong` CTA, correct count should be increased
    func testInputProcessing_whenWrongCTAIsTappedWithNonMatchingWord_shouldUpdateLabelsCorrectly() throws {
        let spanishWords = Constants.getSpanishWords() ?? []
        self.sut.wordAttemptsVM = WordAttemptsVM(spanishWordsList: spanishWords, correctAnswerProbability: 0.0)
        self.sut.wordAttemptsVM.onAttemptMade = self.sut.updateAttemps(correctCount:wrongCount:)
        // Since VM is instantiated, we need to use getNextRandomWord function to show a word
        _ = self.sut.wordAttemptsVM.getNextRandomWord()
        self.sut.wrongButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(self.sut.correctAttemptsCountLabel.text!, "1")
        XCTAssertEqual(self.sut.wrongAttemptsCountLabel.text!, "0")
    }

}
