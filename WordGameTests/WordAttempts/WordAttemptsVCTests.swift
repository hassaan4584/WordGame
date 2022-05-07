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

    func testInputProcessing_whenCorrectCTAIsTappedWithMatchingWord_shouldUpdateLabelsCorrectly() throws {
        let spanishWords = Constants.getSpanishWords() ?? []
        self.sut.wordAttemptsVM = WordAttemptsVM(spanishWordsList: spanishWords, correctAnswerProbability: 1.0)
            // Since VM is instantiated, we need to use getNextRandomWord function to show a word
        _ = self.sut.wordAttemptsVM.getNextRandomWord()
        self.sut.correctButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(self.sut.correctAttemptsCountLabel.text!, "1")
        XCTAssertEqual(self.sut.wrongAttemptsCountLabel.text!, "0")
    }

    func testInputProcessing_whenCorrectCTAIsTappedWithNonMatchingWord_shouldUpdateLabelsCorrectly() throws {
        let spanishWords = Constants.getSpanishWords() ?? []
        self.sut.wordAttemptsVM = WordAttemptsVM(spanishWordsList: spanishWords, correctAnswerProbability: 0.0)
            // Since VM is instantiated, we need to use getNextRandomWord function to show a word
        _ = self.sut.wordAttemptsVM.getNextRandomWord()
        self.sut.correctButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(self.sut.correctAttemptsCountLabel.text!, "0")
        XCTAssertEqual(self.sut.wrongAttemptsCountLabel.text!, "1")
    }

    func testInputProcessing_whenWrongCTAIsTappedWithMatchingWord_shouldUpdateLabelsCorrectly() throws {
        let spanishWords = Constants.getSpanishWords() ?? []
        self.sut.wordAttemptsVM = WordAttemptsVM(spanishWordsList: spanishWords, correctAnswerProbability: 1.0)
            // Since VM is instantiated, we need to use getNextRandomWord function to show a word
        _ = self.sut.wordAttemptsVM.getNextRandomWord()
        self.sut.wrongButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(self.sut.correctAttemptsCountLabel.text!, "0")
        XCTAssertEqual(self.sut.wrongAttemptsCountLabel.text!, "1")
    }

    func testInputProcessing_whenWrongCTAIsTappedWithNonMatchingWord_shouldUpdateLabelsCorrectly() throws {
        let spanishWords = Constants.getSpanishWords() ?? []
        self.sut.wordAttemptsVM = WordAttemptsVM(spanishWordsList: spanishWords, correctAnswerProbability: 0.0)
            // Since VM is instantiated, we need to use getNextRandomWord function to show a word
        _ = self.sut.wordAttemptsVM.getNextRandomWord()
        self.sut.wrongButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(self.sut.correctAttemptsCountLabel.text!, "1")
        XCTAssertEqual(self.sut.wrongAttemptsCountLabel.text!, "0")
    }

}
