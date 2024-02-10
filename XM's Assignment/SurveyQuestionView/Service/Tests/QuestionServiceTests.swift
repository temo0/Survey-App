//
//  QuestionServiceTests.swift
//  XM's AssignmentTests
//
//  Created by Temuri Aroshvili on 10.02.24.
//

import XCTest
@testable import XM_s_Assignment

final class QuestionServiceTests: XCTestCase {
    
    var questionService: QuestionService!
    
    override func setUpWithError() throws {
        questionService = QuestionService()
    }
    
    override func tearDownWithError() throws {
        questionService = nil
    }
    
    func testFetchQuestions() async throws {
        do {
            // When
            let questions = try await questionService.fetchQuestions()
            
            // Then
            XCTAssertFalse(questions.isEmpty, "Fetched questions should not be empty")
        } catch {
            XCTFail("Failed to fetch questions with error: \(error)")
        }
    }
    
    func testSubmitAnswer() async throws {
        do {
            // Given
            let questionID = 1
            let answer = "Sample Answer"
            
            // When
            try await questionService.submitAnswer(questionID: questionID, answer: answer)
            
            // Then
        } catch {
            XCTFail("Failed to submit answer with error: \(error)")
        }
    }
}
