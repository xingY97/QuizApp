//
//  ViewController.swift
//  QuizApp
//
//  Created by XIN on 10/15/20.
//

import UIKit

class ViewController: UIViewController, QuizProtocol {
    
    
    var model = QuizModel()
    //when quizModel gets back with questions, this keep tracks them
    var question = [Question]()
    //keep track of which question the user is currently looking at. starts at index 0
    var currentQuestionIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self
        //get off the QuizModel to fetch questions
        model.getQuestions()
    }

     //Mark: -QuizProtocol Methods
    
    func questionsRetrieved(_ questions: [Question]) {
        print("questions retrieved from model!")
    }

}

