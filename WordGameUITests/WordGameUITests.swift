//
//  WordGameUITests.swift
//  WordGameUITests
//
//  Created by Hassaan Fayyaz Ahmed on 07/05/2022.
//

import XCTest

class WordGameUITests: XCTestCase {

    let app = XCUIApplication()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app.launchArguments = ["UITests"]
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
    }

    /// When the app is launched, correct/wrong buttons should show up but not Restart/Quit buttons
    func testAppLaunchState_whenAppIsLaunched_shouldShowAttemptButtons() throws {
        // Arrange + Act
        let correctButtonExists = app.buttons["Correct"]
        let wrongButtonExists = app.buttons["Wrong"]
        let quitButtonExists = app.buttons["Quit"]
        let restartButtonExists = app.buttons["Restart"]

        // Assert
        XCTAssertTrue(correctButtonExists.exists)
        XCTAssertTrue(wrongButtonExists.exists)
        XCTAssertFalse(quitButtonExists.exists)
        XCTAssertFalse(restartButtonExists.exists)
    }

    /// When the timer expires, the app should show an alert with buttons and text
    func testEndGameDialog_whenTimeoutHappes_DialogShouldAppear() throws {
        XCTAssertTrue(app.buttons["Quit"].waitForExistence(timeout: 16.0))
        XCTAssertTrue(app.buttons["Restart"].exists)
        XCTAssertEqual(app.alerts.element.label, "Game End")
        XCTAssert(app.alerts.element.staticTexts["Do you want to restart ?"].exists)
    }

}
