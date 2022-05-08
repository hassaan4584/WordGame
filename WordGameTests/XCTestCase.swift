//
//  XCTestCase.swift
//  WordGameTests
//
//  Created by Hassaan Fayyaz Ahmed on 08/05/2022.
//

import Foundation
import XCTest

extension XCTestCase {
    /// Creates an expectation for monitoring the given condition.
    /// - Parameters:
    ///   - condition: The condition to evaluate to be `true`.
    ///   - description: A string to display in the test log for this expectation, to help diagnose failures.
    /// - Returns: The expectation for matching the condition.
    func expectation(for condition: @autoclosure @escaping () -> Bool, description: String = "") -> XCTestExpectation {
        let predicate = NSPredicate { _, _ in
            return condition()
        }

        return XCTNSPredicateExpectation(predicate: predicate, object: nil)
    }
}
