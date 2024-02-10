//
//  SurveyQuestionsViewModel.swift
//  XM's Assignment
//
//  Created by Temuri Aroshvili on 10.02.24.
//

import Foundation
import Combine

@MainActor
final class SurveyQuestionsViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var text: String = ""
    @Published private(set) var questions: [SurveyQuestion] = []
    @Published var alertItem: SurveyAlertItem?
    @Published var currentQuestionId: Int?
    
    private(set) var submittedQuestionIds: [Int] = []
    private var cancellables = Set<AnyCancellable>()
    private let questionService = QuestionService()
    
    var question: String? {
        questions.first(where: {
            $0.id == currentQuestionId
        })?.text
    }
    var isSubmitted: Bool {
        guard let currentQuestionId else { return false }
        return submittedQuestionIds.contains(currentQuestionId)
    }
    var caption: String {
        "Submitted: \(isSubmitted ? "Yes": "NO")"
    }
    var submittedAnswer: String? {
        guard let id = currentQuestionId, let submittedQuestion = questions.first(where: {
            $0.id == id
        }) else {
            return nil
        }
        return submittedQuestion.answer
    }
    
    var isSubmitButtonDisabled: Bool {
        isSubmitted || text.isEmpty
    }
    
    var isFirstQuestion: Bool {
        guard let currentQuestionId = currentQuestionId else { return true }
        return questions.first?.id == currentQuestionId
    }
    
    var isLastQuestion: Bool {
        guard let currentQuestionId = currentQuestionId else { return true }
        return questions.last?.id == currentQuestionId
    }
    
    // MARK: - Init
    init() {
        setUpBindings()
    }

    func fetchQuestions() async {
        do {
            let fetchedQuestions = try await questionService.fetchQuestions()
            self.questions = fetchedQuestions.map ({
                .init(id: $0.id, text: $0.question)
            })
            if questions.isEmpty {
                alertItem = .init(id: UUID().uuidString, title: Constants.questionEmptyState)
            } else {
                currentQuestionId = questions.first?.id
            }
        } catch {
            self.alertItem = .init(
                id: UUID().uuidString,
                title: error.localizedDescription
            )
        }
    }
    
    func next() {
        if let index = questions.firstIndex(where: { $0.id == currentQuestionId }),
           questions.indices.contains(index + 1) {
            currentQuestionId = questions[index + 1].id
            text = questions[index + 1].answer ?? ""
        }
    }
    
    func previous() {
        if let index = questions.firstIndex(where: {
            $0.id == currentQuestionId
        }),
           questions.indices.contains(index - 1) {
            currentQuestionId = questions[index - 1].id
            text = questions[index - 1].answer ?? ""
        }
    }
    
    func submit() async {
        guard let id = currentQuestionId else { return }
        do {
            try await questionService.submitAnswer(
                questionID: id,
                answer: submittedAnswer ?? ""
            )
            submittedQuestionIds.append(id)
            objectWillChange.send()
            self.alertItem = .init(id:  UUID().uuidString, title: Constants.submitSuccessText)
        } catch {
            self.alertItem = .init(
                id: UUID().uuidString,
                title: error.localizedDescription
            )
        }
    }
}

// MARK: - Private Methods
private extension SurveyQuestionsViewModel {
    func setUpBindings() {
        $text
            .sink { [weak self] text in
                guard let id = self?.currentQuestionId,
                      var question = self?.questions.first(where: { $0.id == id }),
                      let index = self?.questions.firstIndex(of: question)
                else { return }
                question.answer = text
                self?.questions.remove(at: index)
                self?.questions.insert(question, at: index)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Constants
private extension SurveyQuestionsViewModel {
    enum Constants {
        static let submitSuccessText = "Congratulations! Your answer has been successfully submitted."
        static let questionEmptyState = "No questions avaliable"
    }
}
