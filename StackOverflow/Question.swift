//
//  Question.swift
//  StackOverflow
//
//  Created by Robert Haworth on 5/16/17.
//  Copyright © 2017 Robert Haworth. All rights reserved.
//

import UIKit

class Question:StackDataObject {

    var answerCount:Int {
        get {
            guard let unwrappedCount = dataDictionary["answer_count"] as? Int else {
                return 0
            }
            return unwrappedCount
        }
    }
    
    var isAnswered:Bool? {
        get {
            return dataDictionary["is_answered"] as? Bool
        }
    }
    
    override var id:Int? {
        get {
            return dataDictionary["question_id"] as? Int
        }
    }
    var score:Int? {
        get {
            return dataDictionary["score"] as? Int
        }
    }
    
    var viewCount:Int {
        get {
            guard let unwrappedCount = dataDictionary["view_count"] as? Int else {
                return 0
            }
            return unwrappedCount
        }
    }
    
    // Initialize with default values
    var guessedAnswerID:Int = -1
    
    
    var answers:[Answer]?
    
    func selectGuess(answerID:Int) {
        guessedAnswerID = answerID
    }
    
}
