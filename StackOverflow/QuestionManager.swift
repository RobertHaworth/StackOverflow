//
//  QuestionManager.swift
//  StackOverflow
//
//  Created by Robert Haworth on 5/18/17.
//  Copyright © 2017 Robert Haworth. All rights reserved.
//

import UIKit

private let _sharedInstance = QuestionManager()

class QuestionManager {
    private var questions:[Question] = []
    
    class var sharedInstance:QuestionManager {
        return _sharedInstance
    }
    
    func updateQuestions(newQuestions:[Question]) {
        questions.removeAll()
        questions = newQuestions
    }
    
    // Returns all known questions with an optional filter for questions that have a user guess
    func questions(guessedOnly:Bool) -> [Question] {
        if guessedOnly {
            return questions.filter() { return $0.guessedAnswerID != -1 }
        }
        
        return questions
    }
    
}
