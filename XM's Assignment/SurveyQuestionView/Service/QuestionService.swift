//
//  QuestionService.swift
//  XM's Assignment
//
//  Created by Temuri Aroshvili on 10.02.24.
//

import Foundation

enum APIEndpoint: String {
    case questions
    case submitAnswer = "question/submit"
}

class QuestionService {
    private let baseURL = "https://xm-assignment.web.app"
    
    func fetchQuestions() async throws -> [QuestionDTO] {
        guard let url = URL(string: "\(baseURL)/\(APIEndpoint.questions.rawValue)") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([QuestionDTO].self, from: data)
    }
    
    func submitAnswer(questionID: Int, answer: String) async throws {
        guard let url = URL(string: "\(baseURL)/\(APIEndpoint.submitAnswer.rawValue)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestData: [String: Any] = ["id": questionID, "answer": answer]
        request.httpBody = try JSONSerialization.data(withJSONObject: requestData)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode == 200 {
            return
        } else {
            throw URLError(.badServerResponse)
        }
    }
}
