//
//  ContentView.swift
//  XM's Assignment
//
//  Created by Temuri Aroshvili on 10.02.24.
//

import SwiftUI
import Combine

struct ContentView: View {
    // MARK: - Properties
    @State private var isSurveyStarted = false
    @StateObject private var questionViewModel = SurveyQuestionsViewModel()
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                NavigationLink(
                    destination: SurveyQuestionsView(viewModel: questionViewModel),
                    isActive: $isSurveyStarted
                ) {
                    startSurveyButton
                }
                .isDetailLink(false)

                Spacer()
            }
            .navigationTitle(Constants.buttonTitle)
        }
    }
}

// MARK: - Views
private extension ContentView {
    var startSurveyButton: some View {
        Button("Start Survey") {
            isSurveyStarted.toggle()
        }
        .foregroundColor(.white)
        .padding()
        .background(Color.blue)
        .cornerRadius(Constants.conrerRadius)
    }
}

// MARK: - Constants
private extension ContentView {
    enum Constants {
        static let buttonTitle = "Start Survey"
        static let conrerRadius: CGFloat = 10
    }
}
