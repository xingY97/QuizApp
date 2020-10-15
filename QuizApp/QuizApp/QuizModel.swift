//
//  QuizModel.swift
//  QuizApp
//
//  Created by XIN on 10/15/20.
//

import Foundation

// every class confirms this protocol, must satisfy the protocol requirement
protocol QuizProtocol {
    
    func questionsRetrieved(_ questions:[Question])
    
}

class QuizModel {
    
    var delegate: QuizProtocol?
    
    func getQuestions(){
        
        //when the getQuestions function gets called
        //TODO: Fetch the questions
        
        // Notify the delegate of the retrieved questions
        delegate?.questionsRetrieved([Question]())
    }
    
}
