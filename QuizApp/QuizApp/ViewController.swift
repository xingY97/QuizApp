//
//  ViewController.swift
//  QuizApp
//
//  Created by XIN on 10/15/20.
//

import UIKit

class ViewController: UIViewController, QuizProtocol, UITableViewDelegate, UITableViewDataSource, ResultViewControllerProtocol {
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    //when quizModel gets back with questions, this keep tracks them
    //keep track of which question the user is currently looking at. starts at index 0
    
    var model = QuizModel()
    var questions = [Question]()
    var currentQuestionIndex = 0
    var numCorrect = 0
    
    var resultDialog: ResultViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize the result dialog and animation
        resultDialog = storyboard?.instantiateViewController(identifier: "ResultVC") as? ResultViewController
        resultDialog?.modalPresentationStyle = .overCurrentContext
        resultDialog?.delegate = self
        
        //set self as the delegate and datasource for the tableview
        tableView.delegate = self
        tableView.dataSource = self
        
        //dynamic row heights
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        model.delegate = self
        //get off the QuizModel to fetch questions
        model.getQuestions()
    }
    
    func displayQuestions(){
        
        //check if ther eare questions and check that the currentQuestionIndex is not out of bounds
        guard questions.count > 0 && currentQuestionIndex < questions.count else {
            return
        }
        
        //Display the question text
        questionLabel.text = questions[currentQuestionIndex].question
        
        //Reload the answers table
        tableView.reloadData()
        
    }

     // Mark: -QuizProtocol Methods
    
    func questionsRetrieved(_ questions: [Question]) {
        
        //Get a refrence to the questions
        self.questions = questions
        
        //Check if we should restore the state. before showing question #1
        let savedIndex = StateManager.retrieveValue(key: StateManager.questionIndexKey) as? Int
        
        if savedIndex != nil && savedIndex! < self.questions.count {
            
            //set the current question to the saved index
            currentQuestionIndex = savedIndex!
            
            //Retrieve the number correct from storage
            let savedNumCorrect = StateManager.retrieveValue(key: StateManager.numCorrectKey) as? Int
            if savedNumCorrect != nil {
                numCorrect = savedNumCorrect!
            }
            
        }
        
        //Display the first question
        displayQuestions()
        
    }

    // Mark: UITableView Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Make sure that the questions array actually contains at least one question
        
        guard questions.count > 0 else {
            return 0
        }
        //Return the number of answers for this question
        let currentQuestion = questions[currentQuestionIndex]
        
        if currentQuestion.answers != nil {
            return currentQuestion.answers!.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Get a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        
        //customize it
        let label = cell.viewWithTag(1) as? UILabel
        
        if label != nil {
            
            let question = questions[currentQuestionIndex]
            
            if question.answers != nil && indexPath.row < question.answers!.count {
                //Set the answer text for the label
                label!.text = question.answers![indexPath.row]
            }
            
        }
        //return the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var titleText = ""
        
        //User has tapped on a row, check if it's the right answer
        let question = questions[currentQuestionIndex]
        
        if question.correctAnswerIndex! == indexPath.row {
            //user got it right
            titleText = "Correct!"
            numCorrect += 1
        }
        else {
            //User got it wrong
            titleText = "Wrong!"
            
        }
        //show the popup
        if resultDialog != nil {
            
            //Customize the dialog text
            resultDialog!.titleText = titleText
            resultDialog!.feedbackText = question.feedback!
            resultDialog!.buttonText = "Next"
            
            present(resultDialog!, animated: true, completion: nil)
        }
    }
    
    //Mark: -ResultViewConttollerProtocol Methods
    
    func dialogDismissed() {
        
        //Increment the currentQuestionIndex
        currentQuestionIndex += 1
        
        if currentQuestionIndex == questions.count {
            
            //The user ha sjust answered the last question
            //Show a summary dialog

            if resultDialog != nil {
                
                //Customize the dialog text
                resultDialog!.titleText = "Summary"
                resultDialog!.feedbackText = "You got \(numCorrect) out of \(questions.count) questions!"
                resultDialog!.buttonText = "Restart"
                
                present(resultDialog!, animated: true, completion: nil)
                
                //Clear state
                StateManager.clearState()
            }
            
        }
        else if currentQuestionIndex > questions.count {
            //Restart
            numCorrect = 0
            currentQuestionIndex = 0
            displayQuestions()
        }
        else if currentQuestionIndex < questions.count {
            // more questions to show
            
            //Display the nexxt question
            displayQuestions()
            
            //save state
            StateManager.saveState(numCorrect: numCorrect, questionIndex: currentQuestionIndex)
        }
        

    }
}

