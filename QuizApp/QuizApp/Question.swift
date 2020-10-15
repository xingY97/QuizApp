//
//  Question.swift
//  QuizApp
//
//  Created by XIN on 10/15/20.
//

import Foundation

struct Question {
    
    var question:String?
    var answers:[String]? //there will be multiple choice answers, so set it as an array of string
    var correctAnswerIndex:Int? //specify which answer in correct inside the answers array
    var feedback:String? //feedback to user they got it right or wrong and why
    
}
