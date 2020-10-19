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
        getLocalJsonFile()
    }
    
    func getLocalJsonFile(){
        
        // get bundle path to json file
        let path = Bundle.main.path(forResource: "QuestionData", ofType: "json")
        
        //Double check that the path isn't nil
        guard path != nil else {
            print("couldn't find the json data file")
            return
        }
        
        //Create URL object from the path
        let url = URL(fileURLWithPath: path!)
        
        do {
            //Get the data from the url
            let data = try Data(contentsOf: url)
            
            //try to decode the data into objects
            let decoder = JSONDecoder()
            let array = try
                decoder.decode([Question].self, from: data)
            //Notify the delegste of the parsed objects
            delegate?.questionsRetrieved(array)
        }
        catch {
            //Error: Coulndn't read the data at that URL
        }
    }
    func getRemoteJsonFile(){
        
        
    }
    
}
