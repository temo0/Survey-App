//
//  SurveyQuestionModel.swift
//  XM's Assignment
//
//  Created by Temuri Aroshvili on 10.02.24.
//

struct SurveyQuestion: Hashable, Identifiable {
    let id: Int
    let text: String
    var answer: String?
}
