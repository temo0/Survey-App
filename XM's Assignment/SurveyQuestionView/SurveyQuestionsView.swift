//
//  SurveyQuestionsView.swift
//  XM's Assignment
//
//  Created by Temuri Aroshvili on 10.02.24.
//

import SwiftUI

struct SurveyQuestionsView: View {
    
    // MARK: - Properties
    @ObservedObject private var viewModel: SurveyQuestionsViewModel
    
    // MARK: - Init
    init(viewModel: SurveyQuestionsViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            header
            textField
            Spacer()
            footer
        }
        .padding()
    }
}

// MARK: - Views
private extension SurveyQuestionsView {
    var header: some View {
        VStack(alignment: .leading) {
            Text(viewModel.caption)
                .foregroundStyle(.gray)
                .font(.caption)
            
            if let question = viewModel.question {
                Text(question)
                    .font(.largeTitle)
            }
        }
        .task {
            await viewModel.fetchQuestions()
        }
        
        .alert(item: $viewModel.alertItem) { item in
            Alert(title: Text(item.title))
        }
    }
    
    var textField: some View {
        TextField("", text: $viewModel.text)
            .textFieldStyle(.roundedBorder)
            .disabled(viewModel.isSubmitted)
    }
    
    var submitButton: some View {
        Button(Constants.submitButtonTitle) {
            Task {
                await viewModel.submit()
            }
        }
        .buttonStyle(.borderedProminent)
        .disabled(viewModel.isSubmitButtonDisabled)
    }
    
    var previousButton: some View {
        Button(
            Constants.previousButtonTitle,
            action: viewModel.previous
        )
        .disabled(viewModel.isFirstQuestion)
    }
    
    var nextButton: some View {
        Button(
            Constants.nextButtonTitle,
            action: viewModel.next
        )
        .disabled(viewModel.isLastQuestion)
        
    }
    
    var footer: some View {
        HStack {
            previousButton
            Spacer()
            submitButton
            Spacer()
            nextButton
        }
    }
}

// MARK: - Constants
private extension SurveyQuestionsView {
    enum Constants {
        static let submitButtonTitle = "Submit"
        static let previousButtonTitle = "Previous"
        static let nextButtonTitle = "Next"
    }
}
