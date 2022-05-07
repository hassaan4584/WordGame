//
//  WordGameTests.swift
//  WordGameTests
//
//  Created by Hassaan Fayyaz Ahmed on 07/05/2022.
//

import XCTest
@testable import WordGame

class WordGameTests: XCTestCase {

    static let spanishWordsFileName = "SpanishWords"

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    /// This testcase is to make sure we have the main json data file present in file system.
    func testWordsFile_theFileHasToBePresent_WithGivenName() throws {
        guard let filePath = Bundle.main.url(forResource: WordGameTests.spanishWordsFileName, withExtension: ".json") else {
            XCTFail("\(WordGameTests.spanishWordsFileName).json file not found!")
            return
        }
        guard let data = try? Data(contentsOf: filePath),
                let wordsList = try? JSONDecoder().decode([SpanishWord].self, from: data) else {
            XCTFail("Unable to read data from \(WordGameTests.spanishWordsFileName).json")
            return
        }
        // Since we do not want to modify the data file, making sure count of the words is not modified
        XCTAssertEqual(wordsList.count, 297)
    }

}
