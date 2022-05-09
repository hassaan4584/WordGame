//
//  WordGameTests.swift
//  WordGameTests
//
//  Created by Hassaan Fayyaz Ahmed on 07/05/2022.
//

import XCTest
@testable import WordGame

class WordGameTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    /// This testcase is to make sure we have the main json data file for spanish words present in file system.
    func testSpanishWordsFile_theFileHasToBePresent_WithGivenName() throws {
        let fileName = Constants.spanishWordsFileName

        guard let wordsList: [SpanishWord] = Constants.getWordList(fileName: fileName) else {
            XCTFail("Unable to read data from \(fileName).json")
            return
        }
        // Since we do not want to modify the data file, making sure count of the words is not modified
        XCTAssertEqual(wordsList.count, 297)
    }

}
